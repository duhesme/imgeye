//
//  PhotoManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation
import CloudKit

protocol PhotoManagerDelegate: NSObjectProtocol {
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel])
    func didDownloadPhoto(_ photoManager: PhotoManager, photo: PhotoModel)
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData)
    func didFailWithErrorDownloadingPhotos(error: Error?)
}

struct PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    
    func downloadPhotos(count: Int = 10) {
        performRequest(with: "\(K.photosURL)?count=\(count)")
    }
    
    func downloadPhoto(byID id: String) {
        performRequestForSinglePhotoDownloading(with: "\(K.getPhotoById)\(id)")
    }
    
    private func performRequest(with urlString: String) {
        let parameters = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID \(K.accessKey)"
        ]
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = parameters
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                }
                
                guard let safeData = data else {
                    self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse code: \(httpResponse.statusCode)")
                    
                    let statusCode = httpResponse.statusCode
                    if statusCode != 200 {
                        if let errorMessage = ErrorManager.parseJSON(safeData) {
                            self.delegate?.didFailDownloadingPhotosWithErrorMessage(self, errorData: errorMessage)
                        } else {
                            self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                        }
                    } else {
                        if let safeData = data {
                            if let photos = self.parseJSON(safeData) {
                                self.delegate?.didDownloadPhotos(self, photos: photos)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ photoData: Data) -> [PhotoModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PhotoData].self, from: photoData)
            
            var photos = [PhotoModel]()
            
            for d in decodedData {
                let urls = photoModelURL(raw: URL(string: d.urls.raw)!, full: URL(string: d.urls.full)!, regular: URL(string: d.urls.regular)!, small: URL(string: d.urls.small)!, thumb: URL(string: d.urls.thumb)!)
                
                let dateFormatter = ISO8601DateFormatter()
                let created_at = dateFormatter.date(from: d.created_at)!
                let updated_at = dateFormatter.date(from: d.updated_at)!
                
                var p = PhotoModel(id: d.id, urls: urls, user: d.user, created_at: created_at, updated_at: created_at, likes: d.likes, downloads: d.downloads, location: d.location, tags: d.tags, description: d.description)
                
                DispatchQueue.main.sync {
                    p.isFavorite = DataManager.shared.isPhotoFavorite(basedOnID: p.id)
                }
                
                photos.append(p)
            }
            
            return photos
        } catch {
            print(error)
            delegate?.didFailWithErrorDownloadingPhotos(error: error)
            return nil
        }
    }
    
    private func performRequestForSinglePhotoDownloading(with urlString: String) {
        let parameters = [
            "Accept-Version": "v1",
            "Authorization": "Client-ID \(K.accessKey)"
        ]
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = parameters
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                }
                
                guard let safeData = data else {
                    self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse code: \(httpResponse.statusCode)")
                    
                    let statusCode = httpResponse.statusCode
                    if statusCode != 200 {
                        if let errorMessage = ErrorManager.parseJSON(safeData) {
                            self.delegate?.didFailDownloadingPhotosWithErrorMessage(self, errorData: errorMessage)
                        } else {
                            self.delegate?.didFailWithErrorDownloadingPhotos(error: error)
                        }
                    } else {
                        if let safeData = data {
                            if let photo = self.parseJSONSinglePhoto(safeData) {
                                self.delegate?.didDownloadPhoto(self, photo: photo)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSONSinglePhoto(_ photoData: Data) -> PhotoModel? {
        let decoder = JSONDecoder()
        do {
            let photo = try decoder.decode(PhotoData.self, from: photoData)
            
            let urls = photoModelURL(raw: URL(string: photo.urls.raw)!, full: URL(string: photo.urls.full)!, regular: URL(string: photo.urls.regular)!, small: URL(string: photo.urls.small)!, thumb: URL(string: photo.urls.thumb)!)
            
            let dateFormatter = ISO8601DateFormatter()
            let created_at = dateFormatter.date(from: photo.created_at)!
            let updated_at = dateFormatter.date(from: photo.updated_at)!
            
            var p = PhotoModel(id: photo.id, urls: urls, user: photo.user, created_at: created_at, updated_at: updated_at, likes: photo.likes, downloads: photo.downloads, location: photo.location, tags: photo.tags, description: photo.description)
            
            DispatchQueue.main.sync {
                p.isFavorite = DataManager.shared.isPhotoFavorite(basedOnID: p.id)
            }
            
            return p
        } catch {
            print(error)
            delegate?.didFailWithErrorDownloadingPhotos(error: error)
            return nil
        }
    }
    
}
