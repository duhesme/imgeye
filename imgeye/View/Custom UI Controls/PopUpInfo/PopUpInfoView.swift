//
//  PopInfoView.swift
//  imgeye
//
//  Created by Никита Владимирович on 18.05.2022.
//

import UIKit

class PopUpInfoView: UIView {

    private weak var messageLabel: UILabel!
    
    var transparentBackgroundColor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    @IBInspectable var messageText: String? {
        get { return messageLabel.text }
        set {
            messageLabel.text = newValue
            messageLabel.fitFontForSize(minFontSizeArg: 8, maxFontSizeArg: 17, accuracy: 0.1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.text = "Label"
        messageLabel.numberOfLines = 2
        self.addSubview(messageLabel)
        self.messageLabel = messageLabel
        
        let offset = CGFloat(8)
        
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: offset),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -offset),
            self.messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset)
        ])
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 87/255, green: 87/255, blue: 86/255, alpha: 1.0)
        self.cornerRadius = 12
        self.alpha = 0.9
    }
    
}

