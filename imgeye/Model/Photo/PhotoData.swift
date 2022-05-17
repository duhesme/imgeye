//
//  PhotoData.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

struct PhotoData: Decodable {
    let id: String
    let created_at: String
    let updated_at: String
    let likes: Int
    let downloads: Int?
    let location: Location?
    let tags: [Tag]?
    let urls: photoURL
    let user: User
}

struct photoURL: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Decodable, Hashable {
    let id: String
    let username: String
    let name: String
}

struct Location: Decodable, Hashable {
    let city: String?
    let country: String?
}

struct Tag: Decodable, Hashable {
    let title: String
}
