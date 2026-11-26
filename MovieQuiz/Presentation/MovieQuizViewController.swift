import UIKit

// MARK: - Constants

private enum Constants {
    static let imageViewBorderWidth: CGFloat = 8
    static let tryAgainText = "Попробовать еще раз"
}

final class MovieQuizViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter?

    // MARK: - IBActions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enableButtons(false)

        presenter?.didAnswer(isCorrectAnswer: true)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enableButtons(false)

        presenter?.didAnswer(isCorrectAnswer: false)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDependencies()
    }

    // MARK: - Private methods

    private func configureDependencies() {
        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

        presenter = MovieQuizPresenter(viewController: self)
    }

    private func enableButtons(_ isEnabled: Bool) {
        for button in [yesButton, noButton] {
            button?.isEnabled = isEnabled
        }
    }

    private func showError(title: String, message: String) {
        hideLoadingIndicator()

        let alertModel = AlertModel(title: title, message: message, buttonText: Constants.tryAgainText) { [weak self]
            in
            guard let self else { return }
            self.presenter?.restartGame()
        }

        self.alertPresenter?.showAlert(model: alertModel)
    }

    // MARK: - Internal methods

    func showImageError(message: String) {
        showError(
            title: "Ошибка загрузки изображения",
            message: message
        )
    }

    func showNetworkError(message: String) {
        showError(
            title: "Ошибка",
            message: message
        )
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showResult(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message:  result.text, buttonText: result.buttonText) { [weak self]  in
            guard let self else { return }
            self.presenter?.restartGame()
        }
        self.alertPresenter?.showAlert(model: alertModel)
    }
}

// MARK: - MovieQuizViewControllerProtocol

extension MovieQuizViewController: MovieQuizViewControllerProtocol {

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        imageView.image = UIImage(data: step.image) ?? UIImage()
        counterLabel.text = step.questionNumber

        enableButtons(true)
    }
}

