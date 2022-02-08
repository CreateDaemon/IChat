//
//  UILabel + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import Foundation
import UIKit


extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
