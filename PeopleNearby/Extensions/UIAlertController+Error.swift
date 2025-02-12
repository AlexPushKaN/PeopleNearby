//
//  UIAlertController+Error.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 10.02.2025.
//

import UIKit

extension UIAlertController {
    static func showLocationErrorAlert(controller: UIViewController) {
        let alert = UIAlertController(
            title: "Доступ к геолокации запрещен",
            message: "Пожалуйста, разрешите доступ к геолокации в настройках",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        controller.present(alert, animated: true)
    }
}
