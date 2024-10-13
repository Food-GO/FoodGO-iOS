//
//  AlertManager.swift
//  YoriJori
//
//  Created by 김강현 on 10/13/24.
//
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                   actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
