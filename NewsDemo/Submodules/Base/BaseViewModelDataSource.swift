//
//  ViewModel.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import Foundation
import RxSwift

protocol BaseViewModelDataSource: AnyObject {
	var updateInfo: Observable<Bool> { get }
	var errorResult: Observable<Error> { get }
	var isLoading: Observable<Bool> { get }
	func viewDidLoad()
}
