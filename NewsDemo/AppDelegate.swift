//
//  AppDelegate.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = MainController()
		window?.makeKeyAndVisible()
		return true
	}
}

