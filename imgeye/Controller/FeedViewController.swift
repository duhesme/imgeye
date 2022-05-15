//
//  FeedViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import UIKit
import Kingfisher
import SkeletonView

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var photoManager = PhotoManager()
    var photosArray = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManager.delegate = self
        
        feedTableView.rowHeight = 360
        feedTableView.register(PhotoTableViewCell.nib, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        feedTableView.addSubview(refreshControl)
        
        photoManager.downloadPhotos()
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        photoManager.downloadPhotos()
    }
    
}

extension FeedViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        cell.configure(fromModel: photosArray[indexPath.row])
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PhotoTableViewCell.identifier
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        let index = indexPath.row
        
        photosArray[index].isFavorite = !photosArray[index].isFavorite
        
        let photo = photosArray[index]
        
        if photo.isFavorite {
            DataManager.shared.saveFavorivePhoto(withID: photo.id)
        } else {
            DataManager.shared.deleteFromFavoritesPhoto(withID: photo.id)
        }
        
        cell.update(model: photo)
    }
    
}

extension FeedViewController: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel]) {
        DispatchQueue.main.async {
            self.photosArray.append(contentsOf: photos.filter {
                !self.photosArray.contains($0)
            })

            self.refreshControl.endRefreshing()
            self.feedTableView.reloadData()
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}
