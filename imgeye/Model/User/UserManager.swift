//
//  UserManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation

protocol UserManagerDelegate: NSObjectProtocol {
    func didDownloadUserByUsername(_ userManager: UserManager, user: UserModel)
    func didFailDownloadingUserWithErrorMessage(_ userManager: UserManager, errorData: ErrorData)
    func didFailWithErrorDownloadingUser(error: Error?)
}

struct UserManager {
    
    weak var delegate: UserManagerDelegate?
    
    func downloadUser(byUsername username: String) {
        performRequest(with: "\(K.getUserByUsername)\(username)")
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
                    self.delegate?.didFailWithErrorDownloadingUser(error: error)
                }
                
                guard let safeData = data else {
                    self.delegate?.didFailWithErrorDownloadingUser(error: error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse code: \(httpResponse.statusCode)")
                    
                    let statusCode = httpResponse.statusCode
                    if statusCode != 200 {
                        if let errorMessage = ErrorManager.parseJSON(safeData) {
                            self.delegate?.didFailDownloadingUserWithErrorMessage(self, errorData: errorMessage)
                        } else {
                            self.delegate?.didFailWithErrorDownloadingUser(error: error)
                        }
                    } else {
                        if let safeData = data {
                            if let user = self.parseJSON(safeData) {
                                self.delegate?.didDownloadUserByUsername(self, user: user)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ userData: Data) -> UserModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UserData.self, from: userData)
            
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: decodedData.updated_at)!
            let model = UserModel(id: decodedData.id, update_at: date, username: decodedData.username, name: decodedData.name, profileImageURLs: decodedData.profile_image)
            return model
        } catch {
            print(error)
            delegate?.didFailWithErrorDownloadingUser(error: error)
            return nil
        }
    }
    
}
