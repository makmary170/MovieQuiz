//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Мария Макарова on 25.11.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    // MARK: - Tests

    func testDidReceiveNextQuestionShowsQuizStep() throws {
        // Given
        let mockViewController = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: mockViewController)

        let questionText = "Question text"
        let emptyData = Data([0x01, 0x02, 0x03])
        let question = QuizQuestion(
            image: emptyData,
            text: questionText,
            correctAnswer: true
        )

        // When
        sut.didReceiveNextQuestion(question: question)

        // Then
        let viewModel = try XCTUnwrap(
            mockViewController.questionStepMock
        )

        XCTAssertEqual(viewModel.question, questionText)
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
