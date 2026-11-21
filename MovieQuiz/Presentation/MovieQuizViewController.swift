import UIKit

// MARK: - Constants

private enum Constants {
    static let imageViewBorderWidth: CGFloat = 8

    static let yourResultText = "Ваш результат: "
    static let roundOverText = "Этот раунд окончен!"
    static let playAgainText = "Сыграть еще раз"
    static let gamesCountText = "Количество сыгранных квизов: "
    static let bestGameText = "Рекорд: "
    static let totalAccuracyText = "Средняя точность: "
    static let tryAgainText = "Попробовать еще раз"
}

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private let presenter = MovieQuizPresenter()
    private var statisticService: StatisticServiceProtocol?
    private var currentQuestion: QuizQuestion?

    // MARK: - IBActions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        showResultByAnswer(isCorrectAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        showResultByAnswer(isCorrectAnswer: false)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoadingIndicator()

        configureDependencies()
        questionFactory?.loadData()
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        hideLoadingIndicator()
        guard let question = question else {
            return
        }

        currentQuestion = question
        
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self]  in
            self?.show(quiz: viewModel)
        }
    }

    func didLoadDataFromServer() {
        activityIndicator.isHidden = false
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    func didFailToLoadImage(with error: Error) {
        showImageError(message: error.localizedDescription)
    }

    // MARK: - Private methods

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    private func showImageError(message: String) {

        let alertModel = AlertModel(title: "Ошибка загрузки изображения", message: message, buttonText: Constants.tryAgainText) { [weak self]
            in
            guard let self else { return }
            self.questionFactory?.requestNextQuestion()
        }

        self.alertPresenter?.showAlert(model: alertModel)
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: Constants.tryAgainText) { [weak self]
            in
            guard let self else { return }
            presenter.resetQuestionIndex()
            self.correctAnswers = 0

            self.questionFactory?.loadData()
        }

        self.alertPresenter?.showAlert(model: alertModel)
    }

    private func configureDependencies() {

        let networkClient = NetworkClient()
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader)
        self.questionFactory = questionFactory

        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

        statisticService = StatisticService()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        imageView.image = UIImage(data: step.image) ?? UIImage()
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showResultByAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: isCorrectAnswer == currentQuestion.correctAnswer)
    }

    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            guard let statisticService else { return }
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)

            let formattedDateString = statisticService.bestGame.date.dateTimeString
            let formattedTotalAccuracyString = "\(String(format: "%.2f", statisticService.totalAccuracy))%"

            let messages = [
                "\(Constants.yourResultText) \(correctAnswers)/\(presenter.questionsAmount)",
                "\(Constants.gamesCountText)\(statisticService.gamesCount)",
                "\(Constants.bestGameText)\(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDateString))",
                "\(Constants.totalAccuracyText)\(formattedTotalAccuracyString)"
            ]

            let alertModel = AlertModel(title: Constants.roundOverText, message:  messages.joined(separator: "\n"), buttonText: Constants.playAgainText) { [weak self]  in
                guard let self else { return }
                presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            self.alertPresenter?.showAlert(model: alertModel)
        } else {
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
}
