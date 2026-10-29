//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 29.10.2026.
//

import Foundation
import UIKit

final class StatisticService: StatisticServiceProtocol {

    weak var delegate: UIViewController?
    private let storage: UserDefaults = .standard

    private var totalCorrectAnswers: Int = 0 // общее количество правильных ответов за все игры
    private var totalQuestionsAsked: Int = 0 // общее количество вопросов, заданных за все игры

    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
        case totalAccuracy      // Для общего значения точности
    }

    var gamesCount: Int { // количество сыгранных квизов
        get {
            // Добавьте чтение значения из UserDefaults
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            // Добавьте запись значения newValue в UserDefaults
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult { // рекорд
        get {
            // Добавьте чтение значений полей GameResult(correct, total и date) из UserDefaults,
            // затем создайте GameResult от полученных значений
            GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            // Добавьте запись значений каждого поля из newValue в UserDefaults
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    var totalAccuracy: Double { //  средняя точность правильных ответов за все игры в процентах, процент правильных ответов от общего числа вопросов

        get {
            // Добавьте чтение значения из UserDefaults
            storage.double(forKey: Keys.totalAccuracy.rawValue)
        }

        set {
            // Добавьте запись значения newValue в UserDefaults
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) { // прин: количество правильных ответов и общее число заданных вопросов по окончании
        gamesCount += 1

        // Получаем текущие и инкриментим значения
        let currentTotalCount = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) + count
        let currentTotalQuestions = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) + amount

        // Сохраняем новые значения
        storage.set(currentTotalCount, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(currentTotalQuestions, forKey: Keys.totalQuestionsAsked.rawValue)

        // Пересчитываем и сохраняем среднюю точность
        if currentTotalQuestions > 0 {
            totalAccuracy = (Double(currentTotalCount) / Double(currentTotalQuestions)) * 100
        } else {
            totalAccuracy = 0.0
        }

        // Проверяем является ли текущий результат новым рекордом
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())

        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }
}
