//
//  UILabel+Extensions.swift
//  imgeye
//
//  Created by Никита Владимирович on 18.05.2022.
//

import UIKit

extension UILabel {

    func fitFontForSize(minFontSizeArg : CGFloat = 5.0, maxFontSizeArg : CGFloat = 300.0, accuracy : CGFloat = 1.0) {
        var minFontSize = minFontSizeArg
        var maxFontSize = maxFontSizeArg
            
        assert(maxFontSize > minFontSize)
        layoutIfNeeded() // Can be removed at your own discretion
        let constrainedSize = bounds.size
        while maxFontSize - minFontSize > accuracy {
            let midFontSize : CGFloat = ((minFontSize + maxFontSize) / 2)
            font = font.withSize(midFontSize)
            sizeToFit()
            let checkSize : CGSize = bounds.size
            if  checkSize.height < constrainedSize.height && checkSize.width < constrainedSize.width {
                minFontSize = midFontSize
            } else {
                maxFontSize = midFontSize
            }
        }
        font = font.withSize(minFontSize)
        sizeToFit()
        layoutIfNeeded() // Can be removed at your own discretion
    }

}

