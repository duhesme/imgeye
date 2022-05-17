//
//  InfoViewViewModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation

struct InfoViewModel {
    
    private let model: PhotoModel
    
    var imageURL: URL {
        return model.urls.regular
    }
    
    var likesCount: String {
        return String(model.likes)
    }
    
    var downloadsCount: String {
        guard let count = model.downloads else {
            return "Uknown"
        }
        
        return String(count)
    }
    
    var descriptionText: String {
        return model.description ?? "No description."
    }
    
    var locationString: String {
        if let city = model.location?.city, let country = model.location?.country {
            return "\(city), \(country)"
        }
        if let city = model.location?.city {
            return "\(city)"
        }
        if let country = model.location?.country {
            return "\(country)"
        }
        
        return "Uknown location"
    }
    
    var publicationDate: String {
        return model.created_at.shortString
    }
    
    var updationDate: String {
        return model.updated_at.shortString
    }
    
    init(photoModel model: PhotoModel) {
        self.model = model
    }
    
}
