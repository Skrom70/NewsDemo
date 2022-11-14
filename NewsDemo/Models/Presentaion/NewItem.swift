//
//  New.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 10.11.2022.
//

import Foundation

protocol NewItemMapping {
	func mapToFavoriteNSManangedObject() -> Favorite
	static func mapToItem(json: MostPopularNew) -> NewItem
	static func mapToItem(nsManangedObject: Favorite) -> NewItem
}

struct NewItem {
	internal init(id: String, title: String, abstract: String, publishedDate: String, imagePath: String?, url: String, isFavorite: Bool) {
		self.id = id
		self.title = title
		self.abstract = abstract
		self.publishedDate = publishedDate
		self.imagePath = imagePath
		self.url = url
		self.isFavorite = isFavorite
	}
	
	let id: String
	let title: String
	let abstract: String
	let publishedDate: String
	let imagePath: String?
	let url: String
	var isFavorite: Bool
}


extension NewItem: NewItemMapping {
	func mapToFavoriteNSManangedObject() -> Favorite {
		let new = Favorite(context: CoreDataStack.shared.persistentContainer.viewContext)
		
		new.id = self.id
		new.title = self.title
		new.abstract = self.abstract
		new.publishedDate = self.publishedDate
		new.title = self.title
		new.url = self.url
		new.dateAdded = Date()
		new.imagePath = self.imagePath
		
		return new
	}
	
	static func mapToItem(json: MostPopularNew) -> NewItem {
		let imagePath = json.media.first?.mediaMetadata.first(where: {$0.format == .mediumThreeByTwo440})?.url
		
		let item = NewItem(id: String(json.id),
						   title: json.title,
						   abstract: json.abstract,
						   publishedDate: json.publishedDate,
						   imagePath: imagePath,
						   url: json.url,
						   isFavorite: false)
		
		return item
	}
	
	static func mapToItem(nsManangedObject: Favorite) -> NewItem {
		let item = NewItem(id: nsManangedObject.id,
						   title: nsManangedObject.title,
						   abstract: nsManangedObject.abstract,
						   publishedDate: nsManangedObject.publishedDate,
						   imagePath: nsManangedObject.imagePath,
						   url: nsManangedObject.url,
						   isFavorite: true)
		return item
	}
}
