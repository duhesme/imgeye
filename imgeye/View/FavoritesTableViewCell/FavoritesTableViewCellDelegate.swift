//
//  FavoritesTableViewCellDelegate.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation

protocol FavoritesTableViewCellDelegate: NSObjectProtocol {
    
    func favoriteCellDidPressDeleteButton(atIndexPath indexPath: IndexPath)
    
}
