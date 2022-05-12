//
//  ViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import UIKit
import Kingfisher

class FeedViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoManager = PhotoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManager.delegate = self
        photoManager.downloadPhotos()
    }

}

extension FeedViewController: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoData]) {
        let url = URL(string: photos[0].urls.full)
        DispatchQueue.main.async {
            self.photoImageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
            }
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}

