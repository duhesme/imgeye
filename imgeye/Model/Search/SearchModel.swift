//
//  SearchModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 21.05.2022.
//

import Foundation

struct SearchModel {
    let searchPhrase: String
    let page: Int
    let total_pages: Int
    let photos: [PhotoModel]
}
