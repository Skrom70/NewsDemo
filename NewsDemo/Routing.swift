//
//  Routing.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//

import Foundation
import UIKit

protocol Routing {
	func navigateToDetails(url: String)
}

extension Routing where Self: UIViewController {
	func navigateToDetails(url: String) {		
		let detailsVC = DetailsViewController()
		detailsVC.stringURL = url
		self.navigationController?.pushViewController(detailsVC, animated: true)
	}
}
