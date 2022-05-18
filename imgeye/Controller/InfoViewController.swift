//
//  InfoViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorPictureShadowView: UIView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var likeButton: BounceButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var viewDidDismissHadler: ((_ didChangeState: Bool) -> Void) = { didChangeState in }
    var isStateChanged = false
    
    var photo: PhotoModel?
    var infoViewModel: InfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else {
            return
        }
        
        infoViewModel = InfoViewModel(photoModel: photo) { [weak self] authorProfilePictureURL in
            DispatchQueue.main.async {
                self?.authorAvatarImageView.kf.setImage(with: authorProfilePictureURL) { _ in
                    guard let imageView = self?.authorAvatarImageView else { return }
                    
                    imageView.hideSkeleton()
                    imageView.roundCorners(withCornerRadius: imageView.bounds.height / 2)
                }
            }
        }
        
        authorAvatarImageView.showAnimatedGradientSkeleton()
        photoImageView.kf.setImage(with: infoViewModel.imageURL)
        
        authorUsernameLabel.text = infoViewModel.authorName
        likeButton.setBackgroundImage(infoViewModel.likeButtonImage, for: .normal)
        likesLabel.text = infoViewModel.likesCount
        downloadsLabel.text = infoViewModel.downloadsCount
        contentLabel.text  = infoViewModel.descriptionText
        locationLabel.text = infoViewModel.locationString
        publishedDateLabel.text = infoViewModel.publicationDate
        updatedDateLabel.text = infoViewModel.updationDate
        
        imageContainerView.setShadow(withCornerRadius: 0, shadowRadius: 8, shadowOpacity: 0.33, color: UIColor.black)
        authorAvatarImageView.roundCorners(withCornerRadius: authorAvatarImageView.bounds.height / 2)
        authorPictureShadowView.roundCorners(withCornerRadius: authorPictureShadowView.bounds.height / 2)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDidDismissHadler(isStateChanged)
    }
    
    @IBAction func likeButtonPressed(_ sender: BounceButton) {
        guard let photo = photo else {
            return
        }
        
        isStateChanged = true
        
        infoViewModel.toogleFavoriteState()
        likeButton.setBackgroundImage(infoViewModel.likeButtonImage, for: .normal)
        
        if infoViewModel.isCurrentPhotoInFavorites {
            DataManager.shared.saveFavorivePhoto(withID: photo.id)
        } else {
            DataManager.shared.deleteFromFavoritesPhoto(withID: photo.id)
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: BounceButton) {
        guard let image = infoViewModel.fullUIImage else { return }
        saveToPhotoLibrary(UIImage: image)
    }
    
    func saveToPhotoLibrary(UIImage image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
