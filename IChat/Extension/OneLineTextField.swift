//
//  TextFieldFromView.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit


class OneLineTextField: UITextField {
    
    init(font: UIFont? = .avenir20()) {
        super.init(frame: .zero)
        
        self.font = font
        self.borderStyle = .none
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .textFieldLight()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
