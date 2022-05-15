//
//  FavoriteViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation
import UIKit
import SkeletonView

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var userManager = UserManager()
    
    var favoritesArray = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.downloadUser(byUsername: "guillaumevdn")
        
        favoritesTableView.register(FavoritesTableViewCell.nib, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        favoritesTableView.dataSource = self
    }
    
}

extension FavoriteViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        
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
