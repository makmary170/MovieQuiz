//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by Maria Makarova on 26.11.2026.
//

@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var questionStepMock: QuizStepViewModel?

    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        questionStepMock = step
    }

    func showResult(quiz result: MovieQuiz.QuizResultsViewModel) {
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
    }

    func showLoadingIndicator() {
    }

    func hideLoadingIndicator() {
    }

    func showNetworkError(message: String) {
    }

    func showImageError(message: String) {

    }
}
