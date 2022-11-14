//
//  MostPopularViewModel.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData

protocol MostPopularViewModelDataSource: BaseViewModelDataSource {
	var numberOfRowsInSection: Int { get }
	func infoForRowAt(_ index: Int) -> NewItem
	func isFavorite(index: Int, value: Bool)
	func update(from: MostPopularAPI)
}

final class MostPopularViewModel: MostPopularViewModelDataSource {

	var numberOfRowsInSection: Int { newsList.count }
	var updateInfo: Observable<Bool>
	var errorResult: Observable<Error>
	var isLoading: Observable<Bool>
	
	private let disposeBag = DisposeBag()
	private var newsList = [NewItem]()
	private let newsNetworkHandler: MostPopularNetworkHandling
	private let coreDataStack: CoreDataContrainer
	
	private let updateInfoSubject = PublishSubject<Bool>()
	private let errorResultSubject = PublishSubject<Error>()
	private let loadingSubject = BehaviorSubject<Bool>(value: true)
	
	init(networkHandling networkHandler: MostPopularNetworkHandling = MostPopularNetworkHandler(),
		 coreDataStack: CoreDataContrainer = CoreDataStack.shared) {
		self.newsNetworkHandler = networkHandler
		self.coreDataStack = coreDataStack
		self.updateInfo = updateInfoSubject.asObservable()
		self.errorResult = errorResultSubject.asObservable()
		self.isLoading = loadingSubject.asObservable()
	}
	
	func infoForRowAt(_ index: Int) -> NewItem {
		cacheSync(index)
		return newsList[index]
	}
	
	func viewDidLoad() {
		getMostPopularNews(from: .emailed)
	}
	
	func update(from: MostPopularAPI) {
		getMostPopularNews(from: from)
	}
	

	func getMostPopularNews(from: MostPopularAPI) {
		self.loadingSubject.onNext(true)
		newsNetworkHandler.getMostPopularNews(from: from)
			.subscribe { [weak self] result in
				self?.newsList = result.results.map({NewItem.mapToItem(json: $0)})
				self?.updateInfoSubject.onNext(true)
				self?.loadingSubject.onNext(false)
			} onFailure: { [weak self] error in
				self?.errorResultSubject.on(.next(error))
				self?.loadingSubject.onNext(false)
			}.disposed(by: disposeBag)
	}
	
	func isFavorite(index: Int, value: Bool) {
		value ? addToFavorites(index) : removeFromFavorites(index)
	}
	
	func addToFavorites(_ index: Int) {
		let _ = newsList[index].mapToFavoriteNSManangedObject()
		coreDataStack.saveContext()
		newsList[index].isFavorite = true
	}
	
	func removeFromFavorites(_ index: Int) {
		let fetchRequest = Favorite.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id LIKE %@", newsList[index].id)
		let context = coreDataStack.persistentContainer.viewContext
		if let object = try? context.fetch(fetchRequest).first {
			context.delete(object)
			coreDataStack.saveContext()
			newsList[index].isFavorite = false
		}
	}
	
	
	func cacheSync(_ index: Int) {
		let fetchRequest = Favorite.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id LIKE %@", newsList[index].id)
		let context = coreDataStack.persistentContainer.viewContext
		if let _ = try? context.fetch(fetchRequest).first {
			newsList[index].isFavorite = true
		}
	}
}
