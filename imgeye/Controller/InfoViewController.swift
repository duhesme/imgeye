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
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var photo: PhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else {
            return
        }
        
        let infoViewViewModel = InfoViewModel(photoModel: photo)
        
        photoImageView.kf.setImage(with: infoViewViewModel.imageURL)
        likesLabel.text = infoViewViewModel.likesCount
        downloadsLabel.text = infoViewViewModel.downloadsCount
        contentLabel.text  = infoViewViewModel.descriptionText
        locationLabel.text = infoViewViewModel.locationString
        publishedDateLabel.text = infoViewViewModel.publicationDate
        updatedDateLabel.text = infoViewViewModel.updationDate
        
        imageContainerView.layer.masksToBounds = false
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 0.33
        imageContainerView.layer.shadowRadius = 8
        imageContainerView.layer.cornerRadius = 0
    }
    
}
