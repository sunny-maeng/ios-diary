//
//  Alertable.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/08.
//

import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {

    func showAlert(title: String = "", message: String = "", preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)

        self.present(alert, animated: true)
    }
}
