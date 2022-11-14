//
//  MostPopularNew.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import Foundation

// MARK: - MostPopularJSON
struct MostPopularJSON: Codable {
	let results: [MostPopularNew]
}

struct MostPopularNew: Codable {
	let id: Int
	let title: String
	let abstract: String
	let publishedDate: String
	let media: [Media]
	let url: String
	
	enum CodingKeys: String, CodingKey {
		case url, id, title, abstract, media
		case publishedDate = "published_date"
	}
}

struct Media: Codable {
	let mediaMetadata: [MediaMetadata]

	enum CodingKeys: String, CodingKey {
		case mediaMetadata = "media-metadata"
	}
}


struct MediaMetadata: Codable {
	let url: String
	let format: Format
	let height, width: Int
}

enum Format: String, Codable {
	case mediumThreeByTwo210 = "mediumThreeByTwo210"
	case mediumThreeByTwo440 = "mediumThreeByTwo440"
	case standardThumbnail = "Standard Thumbnail"
}
