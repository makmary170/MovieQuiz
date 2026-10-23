//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 23.10.2026.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(quiz result: QuizResultsViewModel)
}
