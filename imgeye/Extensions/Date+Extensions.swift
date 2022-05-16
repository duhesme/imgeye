//
//  Date+Extensions.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation

extension Date {
    
    var shortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy"
        return dateFormatter.string(from: self)
    }
    
}
