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
            DispatchQueue.main.async {
                completionHandler(UIImage(data: data))
            }
        }
    }
    
    static func download(from url: URL, delegate: URLSessionDownloadDelegate?, downloadTaskReference: inout URLSessionDownloadTask?) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: operationQueue)
        
        downloadTaskReference = session.downloadTask(with: url)
        guard let downloadTask = downloadTaskReference else { return }
        downloadTask.resume()
    }
    
}
