//
//  ProfileScreenViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import UIKit
import SDWebImage

class ProfileScreenViewController: UIViewController {
    
    private let sender: MUser
    private let receiver: MUser
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = .mainWhite()
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel(text: "Jon Finder", font: UIFont.systemFont(ofSize: 20, weight: .light))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel(text: "Hello! My name is Jon.", font: UIFont.systemFont(ofSize: 16, weight: .light))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var textField: InsertableTextField = {
        let textField = InsertableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(sender: MUser, receiver: MUser) {
        self.sender = sender
        self.receiver = receiver
        
        textField.text = ""
        nameLabel.text = receiver.username
        descriptionLabel.text = receiver.description
        imageView.sd_setImage(with: URL(string: receiver.avatarStringURL))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
        setupButtonInRightViewTextField()
    }
}


extension ProfileScreenViewController {
    
    private func setupSubview() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(textField)
        
        // Image view
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        // Container view
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206)
        ])
        
        // Name label
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35)
        ])
        
        // Description label
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
        
        // Text Field
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    private func setupButtonInRightViewTextField() {
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(touchUpSentButton), for: .touchUpInside)
        }
    }
    
    @objc private func touchUpSentButton() {
        guard
            let message = textField.text,
            !message.isEmpty
        else {
            return
        }
        
        guard let button = textField.rightView as? UIButton else { return }
        button.isEnabled = false
        
        let mmessage = MMessage(user: sender, text: message)
        
        FirebaseService.shered.sendingMessage(from: sender, to: receiver, message: mmessage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

