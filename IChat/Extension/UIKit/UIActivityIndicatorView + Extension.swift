//
//  UIActivityIndicatorView + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 21.02.22.
//

import UIKit

extension UIActivityIndicatorView {
    
    convenience init(hidenWhenStoped: Bool) {
        self.init()
        
        backgroundColor = #colorLiteral(red: 0.9467977881, green: 0.9467977881, blue: 0.9467977881, alpha: 1)
        color = #colorLiteral(red: 0.6014422178, green: 0.6364172697, blue: 0.6786863208, alpha: 1)
        alpha = 0.9
        layer.cornerRadius = 5
        clipsToBounds = true
        self.hidesWhenStopped = hidenWhenStoped
        style = .large
    }
}
