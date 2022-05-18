//
//  PopUpInfoHandler.swift
//  imgeye
//
//  Created by Никита Владимирович on 18.05.2022.
//

import Foundation
import UIKit

class PopUpInfoHandler: NSObject, CAAnimationDelegate {
    
    weak var targetView: PopUpInfoView?
    
    let duration: CGFloat
    let completionHandler: () -> Void
    
    init(duration: CGFloat, completionHandler: @escaping () -> Void) {
        self.duration = duration
        self.completionHandler = completionHandler
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        UIView.animate(withDuration: duration) {
            self.targetView?.layer.opacity = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.targetView?.layer.opacity = 0.0
            } completion: { _ in
                self.targetView?.removeFromSuperview()
                self.completionHandler()
            }
        }
    }
    
}

