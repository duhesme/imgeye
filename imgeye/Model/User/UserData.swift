//
//  UserData.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation

struct UserData: Decodable {
    let id: String
    let updated_at: String
    let username: String
    let name: String
    let profile_image: ProfileImageData
}

struct ProfileImageData: Decodable {
    let small: String
    let medium: String
    let large: String
}
