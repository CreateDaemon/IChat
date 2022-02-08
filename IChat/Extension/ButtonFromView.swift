//
//  ButtonFromView.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import Foundation
import UIKit


class ButtonFromView: UIView {
    
    init(lable: UILabel, button: UIButton) {
        super.init(frame: .zero)
        
        lable.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lable)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            lable.topAnchor.constraint(equalTo: self.topAnchor),
            lable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            button.topAnchor.constraint(equalTo: lable.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            self.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
