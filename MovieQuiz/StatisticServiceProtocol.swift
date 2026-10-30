//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 28.10.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // количество завершённых игр
    var bestGame: GameResult { get } // информация о лучшей попытке
    var totalAccuracy: Double { get } //  средняя точность правильных ответов за все игры в процентах

    func store(correct count: Int, total amount: Int)
}
