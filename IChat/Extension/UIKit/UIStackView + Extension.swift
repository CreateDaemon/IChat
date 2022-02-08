//
//  UIStackView + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import Foundation
import UIKit


extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        
        self.axis = axis
        self.spacing = spacing
    }
}
