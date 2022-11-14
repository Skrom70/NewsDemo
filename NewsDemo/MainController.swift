//
//  MainCoordinator.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 10.11.2022.
//

import Foundation
import UIKit


class MainController: UITabBarController {
	
	struct Strings {
		static let tabbarTitle1			= "Most"
		static let tabbarTitle2 		= "Favorites"
	}
	
	struct Icons {
		static let tabbarIcon1 			= UIImage(systemName: "clock")
		static let tabbarSelectedIcon1  = UIImage(systemName: "clock.fill")
		static let tabbarIcon2 			= UIImage(systemName: "star")
		static let tabbarSelectedIcon2 	= UIImage(systemName: "star.fill")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.tintColor = .black
		
		let mostPopularViewModel = MostPopularViewModel()
		let mostPopularVC = MostPopularViewController(viewModel: mostPopularViewModel)
		
		let favoritesViewModel = FavoritesViewModel()
		let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
		
		let navCont1 = UINavigationController(rootViewController: mostPopularVC)
		let navCont2 = UINavigationController(rootViewController: favoritesVC)
		
		navCont1.navigationBar.tintColor = .black
		navCont2.navigationBar.tintColor = .black
		
		navCont1.tabBarItem.title = Strings.tabbarTitle1
		navCont1.tabBarItem.image = Icons.tabbarIcon1
		navCont1.tabBarItem.selectedImage = Icons.tabbarSelectedIcon1
		
		navCont2.tabBarItem.title = Strings.tabbarTitle2
		navCont2.tabBarItem.image = Icons.tabbarIcon2
		navCont2.tabBarItem.selectedImage = Icons.tabbarSelectedIcon2
	
		
		viewControllers = [
			navCont1,
			navCont2
		]
	}
}
