//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 21.11.2026.
//

import Foundation

final class MovieQuizPresenter {

    private var currentQuestionIndex = 0
    let questionsAmount = 10
    var currentQuestion: QuizQuestion?

    weak var viewController: MovieQuizViewController?

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
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

//    func yesButtonClicked() {
//        guard let currentQuestion = currentQuestion else { return }
//
//        let givenAnswer = true
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }

    func showResultByAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: isCorrectAnswer == currentQuestion.correctAnswer)
        }
}

