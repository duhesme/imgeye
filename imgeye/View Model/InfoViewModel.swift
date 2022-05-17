//
//  InfoViewViewModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation
import UIKit

class InfoViewModel: NSObject {
    
    private var model: PhotoModel
    
    private var userManager = UserManager()
    private let didFetchUserProfilePicture: (_ authorProfilePictureURL: URL) -> Void
    
    var imageURL: URL {
        return model.urls.regular
    }
    
    var authorName: String {
        return "\(model.user.name) (\(model.user.username))"
    }
    
    var likeButtonImage: UIImage {
        return model.isFavorite ? Asset.Assets.heartIconActive.image : Asset.Assets.heartIconGray.image
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
    
    var isCurrentPhotoInFavorites: Bool {
        return model.isFavorite
    }
    
    init(photoModel model: PhotoModel, didFetchUserProfilePicture: @escaping (_ authorProfilePictureURL: URL) -> Void) {
        self.model = model
        self.didFetchUserProfilePicture = didFetchUserProfilePicture
        super.init()
        self.userManager.delegate = self
        
        userManager.downloadUser(byUsername: model.user.username)
    }
    
    func toogleFavoriteState() {
        self.model.isFavorite.toggle()
    }
    
    func update(photoModel model: PhotoModel) {
        self.model = model
    }
    
}

extension InfoViewModel: UserManagerDelegate {
    
    func didDownloadUserByUsername(_ userManager: UserManager, user: UserModel) {
        guard let url = URL(string: user.profileImageURLs.small) else { return }
        didFetchUserProfilePicture(url)
    }
    
    func didFailDownloadingUserWithErrorMessage(_ userManager: UserManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingUser(error: Error?) {
        
    }
    
}
