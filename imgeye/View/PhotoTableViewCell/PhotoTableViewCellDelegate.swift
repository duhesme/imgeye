//
//  PhotoTableViewCellDelegate.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import Foundation

protocol PhotoTableViewCellDelegate: NSObjectProtocol {
    
    func photoTableViewCell(didUpdateFavoriteStateTo state: Bool, atIndexPath indexPath: IndexPath)
    
}
