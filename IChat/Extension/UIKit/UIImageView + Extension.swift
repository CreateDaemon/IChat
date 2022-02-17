//
//  UIImageView + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import Foundation
import UIKit


extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
    
    func setupColor(color: UIColor) {
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        image = templateImage
        tintColor = color
    }
}
