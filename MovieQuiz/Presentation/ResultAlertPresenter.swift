//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 23.10.2026.
//

import Foundation
import UIKit

final class ResultAlertPresenter: AlertPresenterProtocol {

    weak var delegate: UIViewController?

    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }

        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
