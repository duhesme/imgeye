//
//  FavoriteViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation
import UIKit
import SkeletonView
import SwipeCellKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var photoManager = PhotoManager()
    
    var favoritesArray = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoManager.delegate = self
        
        favoritesTableView.rowHeight = 148
        favoritesTableView.register(FavoritesTableViewCell.nib, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesArray = []
        guard let favoritePhotos = DataManager.shared.readFavoritePhotos() else { return }
        for favoritePhoto in favoritePhotos {
            photoManager.downloadPhoto(byID: favoritePhoto.id!)
        }
        
        if favoritePhotos.isEmpty {
            favoritesTableView.reloadData()
        }
    }
    
    func deletePhotoFromFavorites(atIndexPath indexPath: IndexPath) {
        DataManager.shared.deleteFromFavoritesPhoto(withID: favoritesArray[indexPath.row].id)
        favoritesArray.remove(at: indexPath.row)
    }
    
}

extension FavoriteViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        cell.delegate = self
        cell.configure(withModel: favoritesArray[indexPath.row])
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FavoritesTableViewCell.identifier
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
}

extension FavoriteViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.deletePhotoFromFavorites(atIndexPath: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}

extension FavoriteViewController: PhotoManagerDelegate {
    
    func didDownloadPhotos(_ photoManager: PhotoManager, photos: [PhotoModel]) {

    }
    
    func didDownloadPhoto(_ photoManager: PhotoManager, photo: PhotoModel) {
        DispatchQueue.main.sync {
            self.favoritesArray.append(photo)
            self.favoritesTableView.reloadData()
        }
    }
    
    func didFailDownloadingPhotosWithErrorMessage(_ photoManager: PhotoManager, errorData: ErrorData) {
        
    }
    
    func didFailWithErrorDownloadingPhotos(error: Error?) {
        
    }
    
}
