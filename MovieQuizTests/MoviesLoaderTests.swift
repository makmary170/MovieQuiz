//
//  MoviesLoaderTests.swift
//  ArrayTests
//
//  Created by Мария Макарова on 13.11.2026.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {

    func testLoadMoviesReturnsMoviesOnSuccess() {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2) // проверим, что пришло 2 тестовых фильма - тк их 2 в стабе
                expectation.fulfill() // данные загрузились
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 4)

    }


    func testLoadMoviesReturnsErrorOnFailure() throws {

        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let sut = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")

        sut.loadMovies { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Unexpected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }
}
