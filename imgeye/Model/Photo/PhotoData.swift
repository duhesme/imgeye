//
//  PhotoData.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

struct PhotoData: Decodable {
    let id: String
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
}
