//
//  SearchData.swift
//  imgeye
//
//  Created by Никита Владимирович on 20.05.2022.
//

import Foundation

struct SearchData: Decodable {
    let total: Int
    let total_pages: Int
    let results: [PhotoData]
}
