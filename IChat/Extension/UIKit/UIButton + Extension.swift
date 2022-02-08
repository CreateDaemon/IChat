//
//  UIButton + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(
        titel: String,
        backgroundColor: UIColor,
        titleColor: UIColor,
        font: UIFont? = .avenir20(),
        isShadow: Bool = false,
        cornerRadius: CGFloat = 4
    ) {
        self.init(type: .system)
        
        self.backgroundColor = backgroundColor
        self.setTitle(titel, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
}
