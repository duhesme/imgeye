//
//  PhotoManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

protocol PhotoManagerDelegate: NSObjectProtocol {
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoData])
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData)
    func didFailWithErrorDownloadingPhotos(error: Error?)
}

struct PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    
    func downloadPhotos() {
        performRequest(with: K.photosURL)
    }
    
//    private func performRequest(with urlString: String, _ id: Int, _ code: Int) {
//        let authParameters = ["Accept-Version": "v1"]
//        let parameters = ["id": id, "code": code]
//
//        let url = URL(string: urlString)!
//        let session = URLSession.shared
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = authParameters
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            guard error == nil else {
//                delegate?.didFailWithErrorAuthorizingUser(self, error: error)
//                return
//            }
//
//            guard let data = data else {
//                delegate?.didFailWithErrorAuthorizingUser(self, error: error)
//                return
//            }
//
//
////                if error != nil {
////                    self.delegate?.didFailWithErrorLoadingUser(error: error)
////                }
////
////                if let safeData = data {
////                    if let user = self.parseJSON(safeData) {
////                        self.delegate?.didLoadUser(self, user: user)
////                    }
////                }
//
//
//            do {
//                //create json object from data
//                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    print("JSON: ")
//                    print(json)
//                    // handle json...
//                }
//
//                //let d = self.parseJSON(data)
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("httpResponse code: \(httpResponse.statusCode)")
//
//                    let statusCode = httpResponse.statusCode
//                    if statusCode == 400 {
//                        if let errorReason = ErrorManager.parseJSON(data) {
//                            self.delegate?.didNotAuthorizeUser(self, reason: errorReason)
//                        } else {
//                            self.delegate?.didFailWithErrorAuthorizingUser(self, error: error)
//                        }
//                    } else {
//                        if let user = self.parseJSON(data) {
//                            self.delegate?.didAuthorizeUser(self, user: user)
//                        }
//                    }
//                }
//            } catch let error {
//                delegate?.didFailWithErrorAuthorizingUser(self, error: error)
//                return
//            }
//        })
//        task.resume()
//    }
    
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
                
                
//                if let safeData = data {
//                    if let photos = self.parseJSON(safeData) {
//                        self.delegate?.didDownloadPhotos(self, photos: photos)
//                    }
//                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ photoData: Data) -> [PhotoData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PhotoData].self, from: photoData)
            return decodedData
        } catch {
            print(error)
            delegate?.didFailWithErrorDownloadingPhotos(error: error)
            return nil
        }
    }
    
}
