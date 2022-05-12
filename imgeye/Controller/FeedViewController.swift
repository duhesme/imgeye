//
//  FeedViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import UIKit
import Kingfisher

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    var photoManager = PhotoManager()
    
    var photos = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManager.delegate = self
        photoManager.downloadPhotos()
        
        //feedTableView.rowHeight = 220
        feedTableView.register(PhotoTableViewCell.nib, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        feedTableView.dataSource = self
        feedTableView.delegate = self
    }

}

extension FeedViewController: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel]) {
        DispatchQueue.main.async {
            self.photos = photos
            self.feedTableView.reloadData()
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        
        cell.setPhotoImage(fromUrl: photos[indexPath.row].urls.small)
        
        return cell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
}
