//
//  UISegmentedControl + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit


extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init()
        
        self.insertSegment(withTitle: first, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 0, animated: true)
        self.selectedSegmentIndex = 0
    }
}
