//
//  ImageSaver.swift
//  imgeye
//
//  Created by Никита Владимирович on 19.05.2022.
//

import UIKit

class ImageSaver: NSObject {
    
    deinit {
        print("[ImageSaver] deinit.")
    }
    
    private var completionHandler: ((_ error: Error?) -> Void) = { error in }
    
    func writeToPhotoAlbum(image: UIImage, completionHandler: @escaping (_ error: Error?) -> Void) {
        self.completionHandler = completionHandler
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completionHandler(error)
    }
    
}
