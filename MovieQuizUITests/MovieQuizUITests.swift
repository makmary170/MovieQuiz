//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Мария Макарова on 14.11.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!


    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }

    func testYesButton() {

        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 3))
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()

        let secondPoster = app.images["Poster"]
        XCTAssertTrue(secondPoster.waitForExistence(timeout: 3))
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
    }

    func testNoButton() {

        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 3))
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()

        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 3))

        let secondPoster = app.images["Poster"]
        XCTAssertTrue(secondPoster.waitForExistence(timeout: 3))
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertTrue(indexLabel.wait(for: \.label, toEqual: "2/10", timeout: 3))
    }

    func testResultAlert() {
        let button = app.buttons["No"]

        for _ in 1...10 {

            XCTAssertTrue(button.waitForExistence(timeout: 3))

            button.tap()
        }

        let lastQwNumber = app.staticTexts["Index"]  // наш путь до алерта окончен
        XCTAssertTrue(lastQwNumber.waitForExistence(timeout: 3))
        XCTAssertTrue(lastQwNumber.wait(for: \.label, toEqual: "10/10", timeout: 3))

        let alert = app.alerts["alert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))

        XCTAssertTrue(alert.wait(for: \.label, toEqual: "Этот раунд окончен!", timeout: 3))
        XCTAssertTrue(alert.wait(for: \.buttons.firstMatch.label, toEqual: "Сыграть ещё раз", timeout: 3))
    }

    func testAlertDismiss() {
        let button = app.buttons["No"]

        for _ in 1...10 {
            XCTAssertTrue(button.waitForExistence(timeout: 3))

            button.tap()
        }

        let lastQwNumber = app.staticTexts["Index"]  // наш путь до алерта окончен
        XCTAssertTrue(lastQwNumber.wait(for: \.label, toEqual: "10/10", timeout: 3)) // последний вопрос

        let alert = app.alerts["alert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))

        alert.buttons.firstMatch.tap() // сыграть еще раз

        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 3))

        XCTAssertFalse(alert.waitForExistence(timeout: 3)) // алерта нет
        XCTAssertTrue(indexLabel.wait(for: \.label, toEqual: "1/10", timeout: 3)) // 1ый вопрос
    }
}
