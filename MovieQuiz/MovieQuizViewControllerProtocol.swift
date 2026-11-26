//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 25.11.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showResult(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
    func showImageError(message: String)
}
