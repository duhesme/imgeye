//
//  InfoViewController.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation
import UIKit
import Progress

class InfoViewController: UIViewController {
    
    deinit {
        infoViewModel.cancelImageDownloading()
    }
    
    @IBOutlet weak var popupMessagesView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageDownloadingProgessView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorPictureShadowView: UIView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    @IBOutlet weak var likeButton: BounceButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var downloadButton: BounceButton!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var viewDidDismissHadler: ((_ didChangeState: Bool) -> Void) = { didChangeState in }
    var isStateChanged = false
    
    var photo: PhotoModel?
    var infoViewModel: InfoViewModel!
    
    let popUpInfoManager = PopUpInfoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let DefaultRingProgressorParameter: RingProgressorParameter = (.proportional, Asset.Colors.imageDownloadingProgressColor.color, 15, 3)
        Prog.start(in: imageDownloadingProgessView, .ring(DefaultRingProgressorParameter))
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
        } imageDownloadingProgessHandler: { [weak self] progress in
            guard let progressParent = self?.imageDownloadingProgessView else { return }
            DispatchQueue.main.async { [weak self] in
                Prog.update(progress, in: progressParent)
                print("[imageDownloadingProgessHandler] progress: \(progress)")
                if progress == 1.0 {
                    self?.downloadButton.setBackgroundImage(Asset.Assets.downloadIcon.image, for: .normal)
                    Prog.dismiss(in: progressParent)
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
            popUpInfoManager.showPopup(in: popupMessagesView, with: Strings.Popup.addedToFavorites)
        } else {
            DataManager.shared.deleteFromFavoritesPhoto(withID: photo.id)
            popUpInfoManager.showPopup(in: popupMessagesView, with: Strings.Popup.removedFromFavorites)
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: BounceButton) {
        infoViewModel.downloadImage { [weak self] uiImage in
            print("Downloaded.")
            guard let progressParent = self?.imageDownloadingProgessView else { return }
            DispatchQueue.main.async {
                self?.downloadButton.setBackgroundImage(Asset.Assets.downloadIcon.image, for: .normal)
                Prog.dismiss(in: progressParent)
            }
        } imageDownloadingProgessHandler: { [weak self] progress in
            print("[imageDownloadingProgessHandler] progress: \(progress)")
            guard let progressParent = self?.imageDownloadingProgessView else { return }
            DispatchQueue.main.async {
                Prog.update(progress, in: progressParent)
            }
        }
        
        //                    guard let image = infoViewModel.fullUIImage else { return }
        //                    let saver = ImageSaver()
        //                    saver.writeToPhotoAlbum(image: image) { [weak self] error in
        //                        guard let view = self?.popupMessagesView else { return }
        //
        //                        guard let error = error else {
        //                            print("Image saved to Photo Library successfuly.")
        //                            self?.popUpInfoManager.showPopup(in: view, with: Strings.Popup.imageSavedSuccesfuly)
        //                            return
        //                        }
        //
        //                        print("[ImageSaver] \(error)")
        //                        self?.popUpInfoManager.showPopup(in: view, with: Strings.Popup.imageNotSaved)
        
    }
    
}
