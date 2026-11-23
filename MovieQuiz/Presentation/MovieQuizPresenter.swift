//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 21.11.2026.
//

import Foundation

// MARK: - Constants

private enum Constants {

    static let yourResultText = "Ваш результат: "
    static let gamesCountText = "Количество сыгранных квизов: "
    static let bestGameText = "Рекорд: "
    static let totalAccuracyText = "Средняя точность: "
    static let tryAgainText = "Попробовать еще раз"
}

final class MovieQuizPresenter: QuestionFactoryDelegate {

    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    private let statisticService: StatisticServiceProtocol!

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController

        let networkClient = NetworkClient()
        statisticService = StatisticService()
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    // MARK: - QuestionFactoryDelegate

        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question else { return }

            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
                self?.viewController?.hideLoadingIndicator()
            }
        }

        func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }

        func didFailToLoadData(with error: Error) {
            viewController?.showNetworkError(message: error.localizedDescription)
        }

        func didFailToLoadImage(with error: Error) {
            viewController?.showImageError(message: error.localizedDescription)
        }

    private var currentQuestionIndex = 0
    var correctAnswers = 0
    let questionsAmount = 10
    var currentQuestion: QuizQuestion?

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }

    func didAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion else { return }
        correctAnswers += isCorrectAnswer ? 1 : 0
        viewController?.showAnswerResult(isCorrect: isCorrectAnswer == currentQuestion.correctAnswer)
        }

    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            viewController?.showResult(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    func makeResultsMessage() -> String {
        guard let statisticService else { return "" }
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let formattedDateString = statisticService.bestGame.date.dateTimeString
        let formattedTotalAccuracyString = "\(String(format: "%.2f", statisticService.totalAccuracy))%"

        let messages = [
            "\(Constants.yourResultText) \(correctAnswers)/\(questionsAmount)",
            "\(Constants.gamesCountText)\(statisticService.gamesCount)",
            "\(Constants.bestGameText)\(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDateString))",
            "\(Constants.totalAccuracyText)\(formattedTotalAccuracyString)"
        ]

        let resultMsg = messages.joined(separator: "\n")

        return resultMsg
    }
}
