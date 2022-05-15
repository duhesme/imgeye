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
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData)
    func didFailWithErrorDownloadingPhotos(error: Error?)
}

struct PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    
    func downloadPhotos(count: Int = 10) {
        performRequest(with: "\(K.photosURL)&count=\(count)")
    }
    
    private func performRequest(with urlString: String) {
        let parameters = ["Accept-Version": "v1"]
        
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
                var p = PhotoModel(id: d.id, urls: urls, user: d.user)
                
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
    
}
