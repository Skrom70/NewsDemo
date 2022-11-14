//
//  UIImage+Favorite.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//

import Foundation
import UIKit

extension UIImage {
	static func removeItem() -> UIImage? {
		let largeFont = UIFont.systemFont(ofSize: 18, weight: .bold)
		let configuration = UIImage.SymbolConfiguration(font: largeFont)
		let image = UIImage(systemName: "xmark.circle", withConfiguration: configuration)
		return image
	}
	
	static func isFavorite(_ value: Bool = true) -> UIImage? {
		let largeFont = UIFont.systemFont(ofSize: 18, weight: .bold)
		let configuration = UIImage.SymbolConfiguration(font: largeFont)
		let image = UIImage(systemName: value ? "star.fill" : "star", withConfiguration: configuration)
		image?.withTintColor(value ? .black : .darkGray)
		return image
	}
}

