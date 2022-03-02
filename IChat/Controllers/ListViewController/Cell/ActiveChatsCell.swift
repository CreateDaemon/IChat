//
//  ActiveChatsCell.swift
//  IChat
//
//  Created by Дмитрий Межевич on 15.02.22.
//

import UIKit
import SDWebImage

class ActiveChatsCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseId = "activeChats"
    
    private var userImage = UIImageView()
    private var userName = UILabel(text: "Name", font: .laoSangamMN20())
    private var lastMessage = UILabel(text: "Message", font: .laoSangamMN18())
    private var gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        backgroundColor = .white
    }
    
}


extension ActiveChatsCell {
    
    func updateCell<U>(data: U) where U : Hashable {
        guard let data = data as? MChat else { fatalError() }
        userImage.sd_setImage(with: URL(string: data.userImageString))
        userName.text = data.username
        lastMessage.text = data.lastMessage
    }
    
    private func setupConstraints() {
        addSubview(userImage)
        addSubview(userName)
        addSubview(lastMessage)
        addSubview(gradientView)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 78),
            userImage.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            userName.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            lastMessage.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lastMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
}

