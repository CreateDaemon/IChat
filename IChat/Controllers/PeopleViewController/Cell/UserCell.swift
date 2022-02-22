//
//  UserCell.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "UserCell"
    
    private let containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let userImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .laoSangamMN20()
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupSubview()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
    }
}

extension UserCell {
    
    func updateCell<U>(data: U) where U : Hashable {
        guard let data = data as? MUser else { fatalError() }
        userNameLabel.text = data.username
        guard let urlImage = URL(string: data.avatarStringURL) else { return }
        userImage.sd_setImage(with: urlImage, placeholderImage: #imageLiteral(resourceName: "avatar"))
    }
    
    private func setupSubview() {
        addSubview(containerView)
        containerView.addSubview(userImage)
        containerView.addSubview(userNameLabel)
        
        // Container View
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // User Image View
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImage.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        // User Name Lable
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8)
        ])
    }
    
    private func setupShadow() {
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
