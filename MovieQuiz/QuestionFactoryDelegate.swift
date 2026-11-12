//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 22.10.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLadImage(with error: Error) // сообщение с ошибкой загрузки изображения
}
