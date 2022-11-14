//
//  FavoritesViewModel.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData

protocol FavoritesViewModelDataSource: BaseViewModelDataSource {
	var numberOfRowsInSection: Int { get }
	func infoForRowAt(_ index: Int) -> NewItem
	func removeFromFavorites(_ index: Int)
	func update()
}


class FavoritesViewModel: FavoritesViewModelDataSource {
	
	var numberOfRowsInSection: Int { newsList.count }
	var updateInfo: Observable<Bool>
	var errorResult: Observable<Error>
	var isLoading: Observable<Bool>
	
	private let disposeBag = DisposeBag()
	private var newsList = [NewItem]()
	private let coreDataStack: CoreDataContrainer
	
	private let updateInfoSubject = PublishSubject<Bool>()
	private let errorResultSubject = PublishSubject<Error>()
	private let loadingSubject = BehaviorSubject<Bool>(value: true)
	
	init(coreDataStack: CoreDataContrainer = CoreDataStack.shared) {
		self.coreDataStack = coreDataStack
		self.updateInfo = updateInfoSubject.asObservable()
		self.errorResult = errorResultSubject.asObservable()
		self.isLoading = loadingSubject.asObservable()
	}
	
	func viewDidLoad() {
		self.getFavoritesNews()
	}
	
	func infoForRowAt(_ index: Int) -> NewItem { return self.newsList[index] }
	
	func removeFromFavorites(_ index: Int) {
		let fetchRequest = Favorite.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id LIKE %@", newsList[index].id)
		let context = coreDataStack.persistentContainer.viewContext
		if let object = try? context.fetch(fetchRequest).first {
			context.delete(object)
			coreDataStack.saveContext()
			update()
		}
	}
	
	func update() {
		getFavoritesNews()
	}
	
	
	func getFavoritesNews() {
		self.loadingSubject.onNext(true)
		
		let request = Favorite.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
		
		do {
			let data = try coreDataStack.persistentContainer.viewContext.fetch(request)
			newsList = data.map({NewItem.mapToItem(nsManangedObject: $0)})
			updateInfoSubject.onNext(true)
			loadingSubject.onNext(false)
		} catch (let error) {
			errorResultSubject.on(.next(error))
			loadingSubject.onNext(false)
		}
	}
}
