//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 28.10.2026.
//

import Foundation

struct GameResult {
    let correct: Int // количество правильных ответов
    let total: Int // количество вопросов квиза
    let date: Date // дату завершения раунда

    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
