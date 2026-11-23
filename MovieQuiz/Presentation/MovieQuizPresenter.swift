//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 21.11.2026.
//

import Foundation

final class MovieQuizPresenter {

    private var currentQuestionIndex = 0
    var correctAnswers = 0
    let questionsAmount = 10
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?

    weak var viewController: MovieQuizViewController?

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
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

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }

        currentQuestion = question

        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self]  in
            self?.viewController?.show(quiz: viewModel)
        }
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
}
