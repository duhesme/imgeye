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
    
    var selectedPhoto: PhotoModel?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
    }
    
    func update() {
        for (index, p) in photosArray.enumerated() {
            photosArray[index].isFavorite = DataManager.shared.isPhotoFavorite(basedOnID: p.id)
        }
        
        feedTableView.reloadData()
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        photoManager.downloadPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoVC = segue.destination as! InfoViewController
        infoVC.photo = selectedPhoto
        infoVC.viewDidDismissHadler = {
            self.update()
        }
    }
    
}

extension FeedViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        cell.photoTableViewCellDelegate = self
        cell.configure(fromModel: photosArray[indexPath.row], withIndexPath: indexPath)
        
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
        selectedPhoto = photosArray[indexPath.row]
        performSegue(withIdentifier: StoryboardSegue.Main.fromFeedToInfo.rawValue, sender: nil)
    }
    
}

extension FeedViewController: PhotoManagerDelegate {
    
    func didDownloadPhoto(_ photoManager: PhotoManager, photo: PhotoModel) {
        
    }
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel]) {
        photosArray.append(contentsOf: photos.filter {
            !photosArray.contains($0)
        })
        
        DispatchQueue.main.sync {
            self.refreshControl.endRefreshing()
            self.feedTableView.reloadData()
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}

extension FeedViewController: PhotoTableViewCellDelegate {
    
    func photoTableViewCell(didUpdateFavoriteStateTo state: Bool, atIndexPath indexPath: IndexPath) {
        let cell = feedTableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        let index = indexPath.row
        
        photosArray[index].isFavorite = state
        
        let photo = photosArray[index]
        
        if photo.isFavorite {
            DataManager.shared.saveFavorivePhoto(withID: photo.id)
        } else {
            DataManager.shared.deleteFromFavoritesPhoto(withID: photo.id)
        }
        
        cell.update(model: photo)
    }
    
}
