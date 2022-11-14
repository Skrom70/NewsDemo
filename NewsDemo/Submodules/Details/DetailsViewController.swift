//
//  DetailViewController.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//

import Foundation
import UIKit
import WebKit

class DetailsViewController: UIViewController, WKUIDelegate {
	
	var webView: WKWebView!
	
	var stringURL = "http://nytimes.com"
	
	override func loadView() {
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.uiDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = false
		if let url = URL(string: stringURL) {
			let myRequest = URLRequest(url: url)
			webView.load(myRequest)
		}
	}	
}
