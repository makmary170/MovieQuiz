//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Мария Макарова on 25.11.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
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
        let presenter = MovieQuizPresenter(viewController: mockViewController)

        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData,
            text: "Question text",
            correctAnswer: true
        )

        let viewModel = presenter.convert(model: question)

        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
