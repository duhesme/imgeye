//
//  InfoViewViewModel.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation
import UIKit

class InfoViewModel: NSObject {
    
    deinit {
        print("[InfoViewModel] deinit.")
    }
    
    private var model: PhotoModel
    private var fullImageForSaving: UIImage?
    private var isImageDownloading = false
    
    fileprivate var downloadTaskReference: URLSessionDownloadTask?
    private var imageDownloader: ImageDownloader?
    
    private var userManager = UserManager()
    private let didFetchUserProfilePicture: (_ authorProfilePictureURL: URL) -> Void
    private var imageDownloadingProgessHandler: (_ progress: Float) -> Void
    
    var imageURL: URL {
        return model.urls.regular
    }
    
    var fullUIImage: UIImage? {
        return fullImageForSaving
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
    
    init(photoModel model: PhotoModel,
         didFetchUserProfilePicture: @escaping (_ authorProfilePictureURL: URL) -> Void,
         imageDownloadingProgessHandler: @escaping (_ progress: Float) -> Void)
    {
        self.model = model
        self.didFetchUserProfilePicture = didFetchUserProfilePicture
        self.imageDownloadingProgessHandler = imageDownloadingProgessHandler
        super.init()
        self.userManager.delegate = self
        
        userManager.downloadUser(byUsername: model.user.username)
        
//        if let savedPhoto = DataManager.shared.read(photoWithID: model.id) {
//            fullImageForSaving = savedPhoto
//        } else {
//            UIImage.download(from: model.urls.full) { [weak self ]image in
//                guard let image = image else {
//                    return
//                }
//                self?.fullImageForSaving = image
//                DataManager.shared.save(photoWithID: model.id, withUIImage: image)
//            }
//        }
    }
    
    func toogleFavoriteState() {
        self.model.isFavorite.toggle()
    }
    
    func update(photoModel model: PhotoModel) {
        self.model = model
    }
    
    func downloadImage(
        completionHandler: @escaping (_ uiImage: UIImage?) -> Void,
        imageDownloadingProgessHandler: @escaping (_ progress: Float) -> Void)
    {
        isImageDownloading = true
        
        imageDownloader = ImageDownloader()
        imageDownloader?.download(from: model.urls.full) { [weak self] uiImage in
            self?.isImageDownloading = false
            completionHandler(uiImage)
        } downloadingProgessHandler: { progress in
            imageDownloadingProgessHandler(progress)
        }
    }
    
    func cancelImageDownloading() {
        if isImageDownloading {
            imageDownloader?.cancelDownload()
            isImageDownloading = false
        }
    }
    
    func saveImage() {
        
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

extension InfoViewModel: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async { [weak self] in
            self?.imageDownloadingProgessHandler(percentDownloaded)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = readDownloadedData(of: location) else { return }
        
        fullImageForSaving = UIImage(data: data)
        print("[urlSession in InfoViewMode] Image downloaded successfuly.")
    }
    
    func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
                
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}
