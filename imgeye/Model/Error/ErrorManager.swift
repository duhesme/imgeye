//
//  ErrorManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import Foundation

struct ErrorManager {
    
    static func parseJSON(_ errorData: Data) -> ErrorData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ErrorData.self, from: errorData)
            print("Error: \(decodedData)")
            return decodedData
        } catch {
            return nil
        }
    }
    
}
