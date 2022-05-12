//
//  PhotoModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

struct PhotoModel {
    let id: String
    let urls: photoModelURL
    let user: User
}

struct photoModelURL {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
