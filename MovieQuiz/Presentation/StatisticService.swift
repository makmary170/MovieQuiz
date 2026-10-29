//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 29.10.2026.
//

import Foundation
import UIKit

final class StatisticService: StatisticServiceProtocol {

    // MARK: - Private Constants

    private let storage: UserDefaults = .standard
    private var totalCorrectAnswers: Int = 0 // общее количество правильных ответов за все игры

    // MARK: - Enums

    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
        case totalAccuracy      // Для общего значения точности
    }

    // MARK: - Attributes

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    var totalAccuracy: Double {
        guard currentTotalQuestions != 0 else { return 0.0 }
        return Double(currentTotalCount) / Double(currentTotalQuestions) * 100
        }

    private var currentTotalCount: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }

        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }

    private var currentTotalQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }

        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }

    // MARK: - Methods

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        currentTotalCount += count
        currentTotalQuestions += amount

        let currentGameResult = GameResult(correct: count, total: amount, date: .now)

        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }
}
