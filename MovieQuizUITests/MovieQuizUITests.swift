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
        sleep(3)

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
    }

    func testNoButton() {
        sleep(3)

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)

        let indexLabel = app.staticTexts["Index"]
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }

    func testResultAlert() {
        sleep(1)

        var qwNumber = app.staticTexts["Index"].label.split(separator: "/")[0]
        while Int(qwNumber) ?? 10 < 10 {
            app.buttons["No"].tap()
            sleep(1)

            qwNumber = app.staticTexts["Index"].label.split(separator: "/")[0]
        }

        let lastQwNumber = app.staticTexts["Index"].label // наш путь до алерта окончен
        XCTAssertEqual(lastQwNumber, "10/10")

        sleep(1)
        app.buttons["No"].tap() // ответим на последний вопрос, что бы появился алерт

        sleep(1)
        let alert = app.alerts["alert"]

        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }


        let lastQwNumber = app.staticTexts["Index"].label // наш путь до алерта окончен
        XCTAssertEqual(lastQwNumber, "10/10")

        let alert = app.alerts["alert"]
        alert.buttons.firstMatch.tap() // сыграть еще раз

        sleep(1)

        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10") // начинаем сначала
    }
}
