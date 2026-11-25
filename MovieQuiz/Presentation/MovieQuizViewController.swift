import UIKit

// MARK: - Constants

private enum Constants {
    static let imageViewBorderWidth: CGFloat = 8
    static let tryAgainText = "Попробовать еще раз"
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!

    // MARK: - IBActions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false

        presenter.didAnswer(isCorrectAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false

        presenter.didAnswer(isCorrectAnswer: false)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoadingIndicator()
        configureDependencies()
    }

    // MARK: - Private methods

    private func configureDependencies() {
        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

        presenter = MovieQuizPresenter(viewController: self)
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func showImageError(message: String) {
        let alertModel = AlertModel(title: "Ошибка загрузки изображения", message: message, buttonText: Constants.tryAgainText) { [weak self]
            in
            guard let self else { return }
            self.presenter.restartGame()
        }

        self.alertPresenter?.showAlert(model: alertModel)
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: Constants.tryAgainText) { [weak self]
            in
            guard let self else { return }
            self.presenter.restartGame()

        }

        self.alertPresenter?.showAlert(model: alertModel)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        imageView.image = UIImage(data: step.image) ?? UIImage()
        counterLabel.text = step.questionNumber
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }

    func showResult(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message:  presenter.makeResultsMessage(), buttonText: result.buttonText) { [weak self]  in
                guard let self else { return }
                self.presenter.restartGame()
            }
            self.alertPresenter?.showAlert(model: alertModel)
    }
}
