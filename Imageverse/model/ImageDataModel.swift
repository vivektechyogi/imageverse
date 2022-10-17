//
//  ImageDataModel.swift
//  Imageverse
//
//  Created by Jai Mataji on 16/10/22.
//

import Foundation

// MARK: - ImageData Model
struct ImageDataModel: Codable {
    let data: [ImageData]?
    let success: Bool?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case status = "status"
    }
}

// MARK: - Image Data
struct ImageData: Codable {
    let id: String?
    let title: String?
    let datumDescription: String?
    let datetime: Double?
    let cover: String?
    let coverWidth: Int?
    let coverHeight: Int?
    let accountUrl: String?
    let accountId: Int?
    let privacy: String?
    let layout: String?
    let views: Int?
    let link: String?
    let ups: Int?
    let downs: Int?
    let points: Int?
    let score: Int?
    let isAlbum: Bool?
    let favorite: Bool?
    let section: String?
    let commentCount: Int?
    let favoriteCount: Int?
    let imagesCount: Int?
    let inGallery: Bool?
    let isAd: Bool?
    let adType: Int?
    let adUrl: String?
    let inMostViral: Bool?
    let includeAlbumAds: Bool?
    let images: [Image]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case datumDescription = "description"
        case datetime = "datetime"
        case cover = "cover"
        case coverWidth = "cover_width"
        case coverHeight = "cover_height"
        case accountUrl = "account_url"
        case accountId = "account_id"
        case privacy = "privacy"
        case layout = "layout"
        case views = "views"
        case link = "link"
        case ups = "ups"
        case downs = "downs"
        case points = "points"
        case score = "score"
        case isAlbum = "is_album"
        case favorite = "favorite"
        case section = "section"
        case commentCount = "comment_count"
        case favoriteCount = "favorite_count"
        case imagesCount = "images_count"
        case inGallery = "in_gallery"
        case isAd = "is_ad"
        case adType = "ad_type"
        case adUrl = "ad_url"
        case inMostViral = "in_most_viral"
        case includeAlbumAds = "include_album_ads"
        case images = "images"
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let title: String?
    let imageDescription: String?
    let datetime: Int?
    let type: String?
    let animated: Bool?
    let width: Int?
    let height: Int?
    let size: Int?
    let views: Int?
    let bandwidth: Int?
    let favorite: Bool?
    let section: String?
    let accountUrl: String?
    let accountId: String?
    let isAd: Bool?
    let inMostViral: Bool?
    let hasSound: Bool?
    let adType: Int?
    let adUrl: String?
    let edited: String?
    let inGallery: Bool?
    let link: String?
    let commentCount: String?
    let favoriteCount: String?
    let ups: String?
    let downs: String?
    let points: String?
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageDescription = "description"
        case datetime = "datetime"
        case type = "type"
        case animated = "animated"
        case width = "width"
        case height = "height"
        case size = "size"
        case views = "views"
        case bandwidth = "bandwidth"
        case favorite = "favorite"
        case section = "section"
        case accountUrl = "account_url"
        case accountId = "account_id"
        case isAd = "is_ad"
        case inMostViral = "in_most_viral"
        case hasSound = "has_sound"
        case adType = "ad_type"
        case adUrl = "ad_url"
        case edited = "edited"
        case inGallery = "in_gallery"
        case link = "link"
        case commentCount = "comment_count"
        case favoriteCount = "favorite_count"
        case ups = "ups"
        case downs = "downs"
        case points = "points"
        case score = "score"
    }
}
