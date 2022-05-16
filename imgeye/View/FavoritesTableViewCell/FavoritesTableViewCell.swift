//
//  FavoritesTableViewCell.swift
//  imgeye
//
//  Created by Никита Владимирович on 15.05.2022.
//

import UIKit
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {

    class var identifier: String {
        return "FavoritesTableViewCell"
    }
    
    class var nib: UINib {
        return UINib(nibName: "FavoritesTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var actualContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.thumbImageView.layer.masksToBounds = true
        self.thumbImageView.layer.cornerRadius = self.thumbImageView.bounds.height / 2.5
        
        self.shadowLayer.layer.masksToBounds = false
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.23
        self.shadowLayer.layer.shadowRadius = 8
        self.shadowLayer.layer.cornerRadius = 8
        
        self.actualContentView.layer.cornerRadius = 8
        self.actualContentView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withModel model: PhotoModel) {
        self.showAnimatedGradientSkeleton()
        setPhotoImage(fromUrl: model.urls.thumb)
        authorNameLabel.text = "\(model.user.name)\n(\(model.user.username))"
    }
    
    private func setPhotoImage(fromUrl url: URL) {
        self.showAnimatedGradientSkeleton()
        
//        let processor = RoundCornerImageProcessor(cornerRadius: thumbImageView.bounds.height / 2)
        thumbImageView.kf.indicatorType = .activity
        thumbImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
//                .processor(processor),
                .transition(.fade(1))
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                self.thumbImageView.layer.masksToBounds = true
//                self.thumbImageView.layer.cornerRadius = self.thumbImageView.bounds.height / 2
                self.hideSkeleton()
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
}
