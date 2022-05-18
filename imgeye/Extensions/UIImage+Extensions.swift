//
//  UIImage+Extensions.swift
//  imgeye
//
//  Created by Никита Владимирович on 18.05.2022.
//

import Foundation
import UIKit

extension UIImage {
    
    static func download(from url: URL, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = try? Data(contentsOf: url) else { return }
            completionHandler(UIImage(data: data))
        }
    }
    
}
