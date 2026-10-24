//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 23.10.2026.
//

import Foundation

struct AlertModel {
    let title: String  // текст заголовка алерта
    let message: String  // текст сообщения алерта
    let buttonText: String  // текст для кнопки алерта
    let completion: () -> Void  // действие по кнопке алерта
}
