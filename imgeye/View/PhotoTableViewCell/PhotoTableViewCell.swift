//
//  PhotoTableViewCell.swift
//  imgeye
//
//  Created by Никита Владимирович on 12.05.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    class var identifier: String {
        return "PhotoTableViewCell"
    }
    
    class var nib: UINib {
        return UINib(nibName: "PhotoTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setPhotoImage(fromUrl url: URL) {
        photoImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
}
