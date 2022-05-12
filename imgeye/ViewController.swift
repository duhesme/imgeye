//
//  ViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import UIKit

class FeedViewController: UIViewController {

    let photoManager = PhotoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManager.downloadPhotos()
    }

}

extension FeedViewController: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoData]) {
        
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}

