//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Мария Макарова on 13.11.2026.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    func testGetValueInRange() throws {

         // Given
        let testArray = [1, 1, 2, 3, 4]

        // When
        let value = testArray[safe: 2]


        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }

    func testGetValueOutOffRange() throws {

         // Given
        let testArray = [1, 1, 2, 3, 4]

        // When
        let value = testArray[safe: 10]

        // Then
        XCTAssertNil(value)
    }

}
