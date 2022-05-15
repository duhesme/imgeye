//
//  FavoritesTableViewCell.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    class var identifier: String {
        return "FavoritesTableViewCell"
    }
    
    class var nib: UINib {
        return UINib(nibName: "FavoritesTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
