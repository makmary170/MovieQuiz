//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Мария Макарова on 25.11.2026.
//

import XCTest
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

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let mockViewController = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: mockViewController)

        let questionText = "Question text"
        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData,
            text: questionText,
            correctAnswer: true
        )

        sut.didReceiveNextQuestion(question: question)

        XCTAssertEqual(mockViewController.questionStepMock?.question, questionText)
        XCTAssertEqual(mockViewController.questionStepMock?.image, emptyData)
        XCTAssertEqual(mockViewController.questionStepMock?.questionNumber, "1/10")
    }
}
