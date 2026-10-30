//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 23.10.2026.
//

import Foundation

struct AlertModel {
    /// Текст заголовка алерта
    let title: String

    /// Текст сообщения алерта
    let message: String

    /// Текст кнопки алерта
    let buttonText: String

    /// Действие, выполняемое при нажатии на кнопку
    let completion: () -> Void
}
