//
//  MostPopularService.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import Foundation
import RxSwift
import Moya

protocol MostPopularNetworkHandling {
	
	func getMostPopularNews(from: MostPopularAPI) -> Single<MostPopularJSON>
}

final class MostPopularNetworkHandler: MostPopularNetworkHandling {
	
	private let provider = MoyaProvider<MostPopularAPI>()
	
	func getMostPopularNews(from: MostPopularAPI) -> Single<MostPopularJSON> {
		provider.rx
			.request(from)
			.filterSuccessfulStatusCodes()
			.map(MostPopularJSON.self)
	}
}
