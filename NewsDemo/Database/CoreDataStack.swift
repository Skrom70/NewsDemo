//
//  CoreDataManager.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 10.11.2022.
//

import Foundation
import CoreData


protocol CoreDataContrainer {
	var persistentContainer: NSPersistentContainer { get }
	func saveContext()
}

class CoreDataStack: CoreDataContrainer {
	
	static let shared = CoreDataStack(modelName: "NewsDemo")
	
	private let modelName: String
	
	private init(modelName: String) {
		self.modelName = modelName
	}
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
