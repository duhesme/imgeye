//
//  PopUpInfoManager.swift
//  imgeye
//
//  Created by Никита Владимирович on 18.05.2022.
//

import Foundation
import UIKit

struct PopInfoViewMessage {
    let view: PopUpInfoView
    let handler: PopUpInfoHandler
}

class PopUpInfoManager: NSObject {
    private var messages: [PopInfoViewMessage] = []
    
    func showPopup(in view: UIView, with text: String, color: UIColor = UIColor(red: 87/255, green: 87/255, blue: 86/255, alpha: 1.0), duration: Double = 2.0, completionHandler: @escaping () -> Void = {}) {
        for m in messages {
            m.view.removeFromSuperview()
        }
        messages = []
        
        let popUpMessage = PopUpInfoView()
        popUpMessage.transparentBackgroundColor = color
        
        let handler = PopUpInfoHandler(duration: duration, completionHandler: completionHandler)
        handler.targetView = popUpMessage
        let message = PopInfoViewMessage(view: popUpMessage, handler: handler)
        
        popUpMessage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popUpMessage)
        
        popUpMessage.layer.opacity = 0.9
        popUpMessage.isUserInteractionEnabled = false
        
        let height = CGFloat(56)
        let offset = CGFloat(16)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: popUpMessage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height),
            popUpMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            popUpMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            popUpMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset)
        ])
        
        popUpMessage.messageText = text
        
        let popUpInfoHeight = CGFloat(56)
        let initialFrame = view.frame
        let targetFrame = popUpMessage.frame
        let initialPosition = CGPoint(x: initialFrame.midX, y: initialFrame.maxY + popUpInfoHeight)
        let targetPosition = CGPoint(x: initialFrame.midX, y: view.safeAreaLayoutGuide.layoutFrame.maxY - popUpInfoHeight + offset)
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 0.9
        
        let moveUp = CABasicAnimation(keyPath: "position")
        moveUp.fromValue = initialPosition
        moveUp.toValue = targetPosition
        
        let fadeInAndMoveUp = CAAnimationGroup()
        fadeInAndMoveUp.animations = [moveUp, fadeIn]
        fadeInAndMoveUp.duration = 0.25
        fadeInAndMoveUp.delegate = message.handler
        
        popUpMessage.layer.add(fadeInAndMoveUp, forKey: nil)
        messages.append(message)
    }
}

