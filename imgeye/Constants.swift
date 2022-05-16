//
//  Constants.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

enum K {
    private static let apiURL = "https://api.unsplash.com/"
    static let accessKey = "clab61R-CUuhMlZekf5TjWcXUdTpKAsZYQ-tSWTIpmM"
    private static let clientIDParameter = "client_id=\(accessKey)"
    
    private static let photos = "photos/"
    private static let randomPhotos = "photos/random/?client_id=\(accessKey)"
    
    static let photosURL = "\(apiURL)\(photos)"
    static let getUserByUsername = "\(apiURL)users/"
    static let getPhotoById = "\(apiURL)/photos/"
}
