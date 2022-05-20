//
//  SearchManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 20.05.2022.
//

import Foundation

protocol SearchManagerDelegate: NSObjectProtocol {
    func didDownloadPhotosBySearch(_ searchManager: SearchManager, photos: [PhotoModel])
    func didFailDownloadingPhotosBySearchWithErrorMessage(_ searchManager: SearchManager, errorData: ErrorData)
    func didFailWithErrorDownloadingPhotosBySearch(error: Error?)
}

struct SearchManager {
    
    weak var delegate: SearchManagerDelegate?
    
    func searchPhotos(byKeyword keyword: String) {
        performRequest(with: "\(K.searchPhotosURL)?page=2&query=\(keyword)")
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
                    self.delegate?.didFailWithErrorDownloadingPhotosBySearch(error: error)
                }
                
                guard let safeData = data else {
                    self.delegate?.didFailWithErrorDownloadingPhotosBySearch(error: error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse code: \(httpResponse.statusCode)")
                    
                    let statusCode = httpResponse.statusCode
                    if statusCode != 200 {
                        if let errorMessage = ErrorManager.parseJSON(safeData) {
                            self.delegate?.didFailDownloadingPhotosBySearchWithErrorMessage(self, errorData: errorMessage)
                        } else {
                            self.delegate?.didFailWithErrorDownloadingPhotosBySearch(error: error)
                        }
                    } else {
                        if let safeData = data {
                            if let photos = self.parseJSON(safeData) {
                                self.delegate?.didDownloadPhotosBySearch(self, photos: photos)
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
            let decodedData = try decoder.decode(SearchData.self, from: photoData)
            let decodedPhotos = decodedData.results
            
            var photos = [PhotoModel]()
            for d in decodedPhotos {
                let urls = photoModelURL(raw: URL(string: d.urls.raw)!, full: URL(string: d.urls.full)!, regular: URL(string: d.urls.regular)!, small: URL(string: d.urls.small)!, thumb: URL(string: d.urls.thumb)!)
                
                let dateFormatter = ISO8601DateFormatter()
                let created_at = dateFormatter.date(from: d.created_at)!
                let updated_at = dateFormatter.date(from: d.updated_at)!
                
                var p = PhotoModel(id: d.id, urls: urls, user: d.user, created_at: created_at, updated_at: updated_at, likes: d.likes, downloads: d.downloads, location: d.location, tags: d.tags, description: d.description)
                
                DispatchQueue.main.sync {
                    p.isFavorite = DataManager.shared.isPhotoFavorite(basedOnID: p.id)
                }
                
                photos.append(p)
            }
            
            print(photos)
            return photos
        } catch {
            print(error)
            delegate?.didFailWithErrorDownloadingPhotosBySearch(error: error)
            return nil
        }
    }
    
}
