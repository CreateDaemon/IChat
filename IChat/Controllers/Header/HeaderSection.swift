//
//  HeaderSection.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import UIKit

class HeaderSection: UICollectionReusableView {
    
    static let reuseId = "HeaderSection"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HeaderSection {
    
    func configure(textHeader: String, font: UIFont?, textColor: UIColor) {
        label.text = textHeader
        label.font = font
        label.textColor = textColor
    }
}
