//
//  ChoosePhotoView.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit


class ChoosePhotoView: UIView {
    
    private let photo: UIImageView = {
        let photo = UIImageView()
        photo.image = #imageLiteral(resourceName: "avatar")
        photo.contentMode = .center
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.borderColor = UIColor.black.cgColor
        photo.layer.borderWidth = 1
        return photo
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = photo.frame.width / 2
    }
}



extension ChoosePhotoView {
    
    private func setupConstaints() {
        
        addSubview(photo)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.heightAnchor.constraint(equalToConstant: 120),
            photo.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        bottomAnchor.constraint(equalTo: photo.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
    }
}
