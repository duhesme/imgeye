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
    
    @IBOutlet weak var popUpMessagesView: UIView!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedSearchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    
    var photosArray: [PhotoModel] {
        get {
            return viewModel.photosArray
        }
        set {
            viewModel.photosArray = newValue
        }
    }
    
    let popUpInfoManager = PopUpInfoManager()
    
    var selectedPhoto: PhotoModel?
    
    let searchBarMaxInputLength = 128
    
    var viewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        feedSearchBar.delegate = self
        
        feedTableView.rowHeight = 360
        feedTableView.register(PhotoTableViewCell.nib, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        feedTableView.addSubview(refreshControl)
        
        viewModel.downloadRandomPhotos()
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
        viewModel.refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoVC = segue.destination as! InfoViewController
        infoVC.photo = selectedPhoto
        infoVC.viewDidDismissHadler = { didChangeState in
            if didChangeState {
                self.update()
            }
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

extension FeedViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = photosArray[indexPath.row]
        performSegue(withIdentifier: StoryboardSegue.Main.fromFeedToInfo.rawValue, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let cell = feedTableView.visibleCells.last as? PhotoTableViewCell, let index = cell.indexPath?.row else { return }
        viewModel.loadNewPageOfPhotos(indexOfLastVisiblePhoto: index)
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
            popUpInfoManager.showPopup(in: popUpMessagesView, with: Strings.Popup.addedToFavorites)
        } else {
            DataManager.shared.deleteFromFavoritesPhoto(withID: photo.id)
            popUpInfoManager.showPopup(in: popUpMessagesView, with: Strings.Popup.removedFromFavorites)
        }
        
        cell.update(model: photo)
    }
    
}

extension FeedViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText != "" else { return }
        viewModel.downloadPhotos(bySearchPhrase: searchText)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            viewModel.refresh()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= searchBarMaxInputLength
    }
    
}

extension FeedViewController: FeedViewModelDelegate {
    
    func didDownload(photos: [PhotoModel], to indexPaths: [IndexPath]?) {
        DispatchQueue.main.sync {
            refreshControl.endRefreshing()
            if let indexPaths = indexPaths {
                feedTableView.insertRows(at: indexPaths, with: .fade)
            } else {
                feedTableView.reloadData()
            }
        }
    }
    
}
