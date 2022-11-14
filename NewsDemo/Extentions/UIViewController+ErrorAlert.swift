//
//  UIViewController+ErrorAlert.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//

import Foundation
import UIKit

extension UIViewController {
	func showErrorAlert(title: String = "An error has occurred", message: String, action: (()->Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
			action?()
		}))
		self.present(alert, animated: true)
	}
}
