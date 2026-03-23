//
//  UIAlert+Ext.swift
//  MinhasFinancas
//
//  Created by edson lima on 13/02/26.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Helper para alertas (evita repetição de código)
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion?()
        }

        alert.addAction(action)

        present(alert, animated: true)
    }
    
}
