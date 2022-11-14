//
//  FavoritesViewController.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 10.11.2022.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Segmentio
import Alamofire
import Kingfisher

final class FavoritesViewController: UIViewController, BaseViewProtocol, Routing {
	
	struct Icons {
		static let navigationTitle    = UIImage(named: "news")
	}
	
	private let disposeBag = DisposeBag()
	
	private var viewModel: FavoritesViewModelDataSource!
	
	init(viewModel: FavoritesViewModelDataSource) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	lazy var tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupViewModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.viewModel.update()
	}
	
	private func setupUI() {
		
		view.addSubview(tableView)

		tableView.snp.makeConstraints {
			$0.leading.equalToSuperview()
			$0.top.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		configurateTableView()
		
		self.navigationItem.titleView = UIImageView(image: Icons.navigationTitle)
		
	}
	
	private func configurateTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.id)
		
		tableView.separatorStyle = .none
	}
	
	private func setupViewModel() {
		viewModel.updateInfo
			.asDriver(onErrorJustReturn: false)
			.drive(onNext: { [weak self] _ in
				self?.tableView.reloadData()
			}).disposed(by: disposeBag)
		
		viewModel.errorResult
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] error in
				self?.showErrorAlert(message: error.localizedDescription)
			}).disposed(by: disposeBag)
		
		viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)
		
		viewModel.viewDidLoad()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.numberOfRowsInSection
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.id) as? NewsTableCell else {
			return UITableViewCell()
		}
		
		let item = viewModel.infoForRowAt(indexPath.row)
		
		let action = { [weak self] in
			guard let `self` = self else {return}
			self.viewModel.removeFromFavorites(indexPath.row)
		}
		
		cell.setup(title: item.title, subtitle: item.abstract, mediaImageURL: URL(string: item.imagePath ?? ""),
				   isFavorite: nil, favoriteButtonAction: action)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.navigateToDetails(url: viewModel.infoForRowAt(indexPath.row).url)
	}
}
