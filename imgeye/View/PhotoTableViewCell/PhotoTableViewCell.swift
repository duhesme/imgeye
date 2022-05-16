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
    
    weak var delegate: PhotoTableViewCellDelegate?
    
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var actualContentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    private var model: PhotoModel?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.actualContentView.layer.cornerRadius = 8
        self.actualContentView.layer.masksToBounds = true
        
        self.shadowLayer.layer.masksToBounds = false
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.23
        self.shadowLayer.layer.shadowRadius = 8
        self.shadowLayer.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(fromModel model: PhotoModel, withIndexPath indexPath: IndexPath) {
        self.model = model
        self.indexPath = indexPath
        
        setPhotoImage(fromUrl: model.urls.regular)
        
        if model.isFavorite {
            likeButton.setBackgroundImage(Asset.Assets.heartIconActive.image, for: .normal)
        } else {
            likeButton.setBackgroundImage(Asset.Assets.heartIconGray.image, for: .normal)
        }
    }
    
    func update(model: PhotoModel) {
        self.model = model
    }
    
    private func setPhotoImage(fromUrl url: URL) {
        self.showAnimatedGradientSkeleton()
        
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .transition(.fade(1))
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                self.hideSkeleton()
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let model = model, let indexPath = indexPath else {
            return
        }
        
        if model.isFavorite {
            likeButton.setBackgroundImage(Asset.Assets.heartIconGray.image, for: .normal)
        } else {
            likeButton.setBackgroundImage(Asset.Assets.heartIconActive.image, for: .normal)
        }
        
        delegate?.photoTableViewCell(didUpdateFavoriteStateTo: !model.isFavorite, atIndexPath: indexPath)
    }
    
}
