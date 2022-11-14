//
//  NewsTableCell.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import UIKit
import Kingfisher

class NewsTableCell: UITableViewCell, BaseViewProtocol {
	
	static let id = "NewsTableCell"

	lazy var title = UILabel()
	lazy var subtitle = UILabel()
	lazy var mediaImage = UIImageView()
	lazy var favorite = UIButton(type: .system)
	
	private var favoriteButtonAction: (() -> Void)?
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configure()
	}
	
	func setup(title: String, subtitle: String,
			   mediaImageURL: URL?, isFavorite: Bool? = nil,
			   favoriteButtonAction: (() -> Void)?) {
		self.title.text = title
		self.subtitle.text = subtitle
		if let url = mediaImageURL {
			self.mediaImage.kf.setImage(with: url)
		}
		
		if let isFavorite = isFavorite {
			self.favorite.setImage(UIImage.isFavorite(isFavorite), for: .normal)
		} else {
			self.favorite.setImage(UIImage.removeItem(), for: .normal)
		}

		self.favoriteButtonAction = favoriteButtonAction
	}
	
	func configure() {
		self.contentView.addSubview(subtitle)
		self.contentView.addSubview(mediaImage)
		self.contentView.addSubview(title)
		self.contentView.addSubview(favorite)
		
		mediaImage.snp.makeConstraints {
			$0.left.equalTo(safeAreaLayoutGuide.snp.left)
			$0.right.equalTo(safeAreaLayoutGuide.snp.right)
			$0.top.equalToSuperview().offset(24)
			$0.height.equalTo(250)
		}
		
		title.snp.makeConstraints {
			$0.left.equalToSuperview().inset(20)
			$0.right.equalToSuperview().inset(20)
			$0.bottom.equalTo(mediaImage.snp.bottom).inset(10)
		}
		
		favorite.snp.makeConstraints {
			$0.right.equalToSuperview().inset(4)
			$0.top.equalTo(mediaImage.snp.bottom).offset(10)
			$0.width.equalTo(50)
			$0.height.equalTo(50)
		}
		
		subtitle.snp.makeConstraints {
			$0.left.equalToSuperview().offset(16)
			$0.right.equalTo(favorite.snp.left)
			$0.top.equalTo(mediaImage.snp.bottom).offset(10)
			$0.bottom.equalToSuperview().inset(20)
		}

		
		title.numberOfLines = 0
		subtitle.numberOfLines = 0
		
		title.font = UIFont.title
		subtitle.font = UIFont.subtitle
		subtitle.textColor = .black.withAlphaComponent(0.8)
		subtitle.textAlignment = .justified
		subtitle.numberOfLines = 3
		
		title.textColor = .white
		title.layer.shadowColor = UIColor.black.cgColor
		title.layer.shadowRadius = 3.0
		title.layer.shadowOpacity = 1.0
		title.layer.shadowOffset = CGSize(width: 4, height: 4)
		title.layer.masksToBounds = false
		
		let separator = UIView()
		
		addSubview(separator)
	
		separator.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.bottom.equalToSuperview().inset(0)
			$0.height.equalTo(4)
			$0.width.equalTo(Int(UIScreen.main.bounds.width / 10))
		}

		separator.backgroundColor = .black.withAlphaComponent(0.7)
		separator.layer.cornerRadius = 2
		
		favorite.tintColor = .black.withAlphaComponent(0.9)
		favorite.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
		
	}
	
	@objc func favoriteButtonTapped() {
		self.favoriteButtonAction?()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
