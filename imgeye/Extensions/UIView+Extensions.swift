//
//  UIView+Extensions.swift
//  imgeye
//
//  Created by Никита Владимирович on 17.05.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(withCornerRadius radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
    }
    
    func setShadow(withCornerRadius radius: CGFloat, shadowRadius sRadius: CGFloat, shadowOpacity opacity: Float, color: UIColor, shadowOffset offset: CGSize = CGSize(width: 0, height: 0)) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = sRadius
        self.layer.cornerRadius = radius
    }
    
}
