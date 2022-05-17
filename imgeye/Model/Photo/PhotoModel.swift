//
//  PhotoModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

struct PhotoModel: Hashable {
    static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let urls: photoModelURL
    let user: User
    let created_at: Date
    let updated_at: Date
    let likes: Int
    let downloads: Int?
    let location: Location?
    let tags: [Tag]?
    var isFavorite: Bool = false
}

struct photoModelURL: Hashable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
