//
//  MostPopularAPI.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import Foundation
import Moya

enum MostPopularAPI: String {
	
	case emailed, shared, viewed

	fileprivate static let basePath = "https://api.nytimes.com/svc/mostpopular/v2/"
	
	fileprivate static let apiKey = "CjoZTYEVPxctEkNk9k1XJ8r7G0L63SqA"
	
	fileprivate static let period = String(30) // period in days
}

extension MostPopularAPI: TargetType {

	var baseURL: URL {
		return URL(string: MostPopularAPI.basePath)!
	}

	var path: String {
		return self.rawValue + "/" + MostPopularAPI.period + ".json"
	}

	var method: Moya.Method {
		return .get
	}

	var sampleData: Data {
		return Data()
	}

	var task: Task {
		return .requestParameters(parameters: ["api-key" : MostPopularAPI.apiKey], encoding: URLEncoding.default)
	}

	var headers: [String : String]? {
		return ["Content-Type": "application/json"]
	}
}
