//
//  ViewController.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Segmentio
import Alamofire
import Kingfisher

final class MostPopularViewController: UIViewController, BaseViewProtocol, Routing {
	
	struct Strings {
		static let segmenteItemTitle1 = "Most emailed"
		static let segmenteItemTitle2 = "Most shared"
		static let segmenteItemTitle3 = "Most viewed"
	}
	
	struct Icons {
		static let navigationTitle    = UIImage(named: "news")
	}
	
	private let disposeBag = DisposeBag()
	
	private var viewModel: MostPopularViewModelDataSource!
	
	init(viewModel: MostPopularViewModelDataSource) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	lazy var tableView = UITableView()
	lazy var segmentioView = Segmentio()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupViewModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateBySegmentIndex(segmentioView.selectedSegmentioIndex)
	}
	
	private func setupUI() {
		
		self.view.backgroundColor = .white
		
		view.addSubview(tableView)
		view.addSubview(segmentioView)

		segmentioView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			$0.leading.equalToSuperview()
			$0.trailing.equalToSuperview()
			$0.height.equalTo(50)
		}
		
		tableView.snp.makeConstraints {
			$0.leading.equalToSuperview()
			$0.top.equalTo(segmentioView.snp.bottom)
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		configurateTableView()
		configurateTopTabs()
		
		self.navigationItem.titleView = UIImageView(image: Icons.navigationTitle)
	}
	
	private func configurateTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.id)
		
		tableView.separatorStyle = .none
	}
	
	private func configurateTopTabs() {
		let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 3, color: .black)
		
		let state = SegmentioState(
			backgroundColor: .white,
			titleFont: UIFont.segment,
			titleTextColor: .black.withAlphaComponent(0.8)
		)
		
		let options = SegmentioOptions(
			backgroundColor: .white,
			segmentPosition: .dynamic,
			scrollEnabled: true,
			indicatorOptions: indicatorOptions,
			horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(
				type: SegmentioHorizontalSeparatorType.topAndBottom, // Top, Bottom, TopAndBottom
				height: 0
			),
			verticalSeparatorOptions: .none,
			labelTextAlignment: .center,
			segmentStates: SegmentioStates(defaultState: state,
										   selectedState: state,
										   highlightedState: state)
		)
		
		segmentioView.setup(
			content: [SegmentioItem(title: Strings.segmenteItemTitle1, image: nil),
					  SegmentioItem(title: Strings.segmenteItemTitle2, image: nil),
					  SegmentioItem(title: Strings.segmenteItemTitle3, image: nil),
					  
					 ],
			style: .onlyLabel,
			options: options
		)
		
		segmentioView.selectedSegmentioIndex = 0
		
		segmentioView.valueDidChange = { segmentio, segmentIndex in
			self.updateBySegmentIndex(segmentIndex)
			
		}
	}
	
	private func updateBySegmentIndex(_ value: Int) {
		switch value {
			case 0:
				self.viewModel.update(from: .emailed)
			case 1:
				self.viewModel.update(from: .shared)
			case 2:
				self.viewModel.update(from: .viewed)
			default:
				break;
		}
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

extension MostPopularViewController: UITableViewDelegate, UITableViewDataSource {
	
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
			
			let favoriteValue = !self.viewModel.infoForRowAt(indexPath.row).isFavorite
			self.viewModel.isFavorite(index: indexPath.row, value: favoriteValue)
			cell.favorite.setImage(UIImage.isFavorite(favoriteValue), for: .normal)
		}
		
		cell.setup(title: item.title, subtitle: item.abstract, mediaImageURL: URL(string: item.imagePath ?? ""),
				   isFavorite: item.isFavorite, favoriteButtonAction: action)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		view.endEditing(true)
		self.navigateToDetails(url: viewModel.infoForRowAt(indexPath.row).url)
	}
}
