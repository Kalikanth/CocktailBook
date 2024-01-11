//
//  ViewControllerProtocol.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import Foundation
import UIKit
import SwiftUI

protocol AlertViewProtocol {
    func showAlert(title: String,message:String,preferredStyle: UIAlertController.Style)
    func showAlert(title: String,message:String,preferredStyle: UIAlertController.Style,actions: [UIAlertAction])
}

protocol ViewControllerPortocol: AlertViewProtocol {
    func showLoader(_ visible: Bool)
}

extension ViewControllerPortocol where Self: UIViewController {
    
    func showLoader(_ visible: Bool) {
        if visible {
            LoderView.buildLoaderView(for: self)
        }else {
            let loaderView = self.children.filter({ $0 is UIHostingController<LoderView> }).first
            loaderView?.view.removeFromSuperview()
            loaderView?.removeFromParent()
        }
    }
    
    func showAlert(title: String, message: String,preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction.ok())
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction.ok())
        actions.forEach { action in
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}

