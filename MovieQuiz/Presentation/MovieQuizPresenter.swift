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
}
