import UIKit

// MARK: - Constants
private enum Constants {
    static let imageViewBorderWidth: CGFloat = 8
    static let questionsAmount = 10
    static let answerDisplayDuration: TimeInterval = 1

    static let yourResultText = "Ваш результат: "
    static let roundOverText = "Этот раунд окончен!"
    static let playAgainText = "Сыграть еще раз"
    static let gamesCountText = "Количество сыгранных квизов: "
    static let bestGameText = "Рекорд: "
    static let totalAccuracyText = "Средняя точность: "
}

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
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
        configureDependencies()
        questionFactory?.requestNextQuestion()
    }

    private func configureDependencies() {
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory

        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

        statisticService = StatisticService()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self]  in
            self?.show(quiz: viewModel)
        }
    }

    // MARK: - Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(Constants.questionsAmount)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        textLabel.text = step.question
        imageView.image = step.image
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
        if currentQuestionIndex == Constants.questionsAmount - 1 {
            guard let statisticService else { return }
            statisticService.store(correct: correctAnswers, total: 10)

            let formattedDateString = statisticService.bestGame.date.dateTimeString
            let formattedTotalAccuracyString = "\(String(format: "%.2f", statisticService.totalAccuracy))%"

            let messages = [
                "\(Constants.yourResultText) \(correctAnswers)/\(Constants.questionsAmount)",
                "\(Constants.gamesCountText)\(statisticService.gamesCount)",
                "\(Constants.bestGameText)\(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDateString))",
                "\(Constants.totalAccuracyText)\(formattedTotalAccuracyString)"
            ]

            let alertModel = AlertModel(title: Constants.roundOverText, message:  messages.joined(separator: "\n"), buttonText: Constants.playAgainText) { [weak self]  in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            self.alertPresenter?.showAlert(model: alertModel)
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
}
