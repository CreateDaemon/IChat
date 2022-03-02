//
//  ChatRequestViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "human2")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = .mainWhite()
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(text: "Jon Finder", font: UIFont.systemFont(ofSize: 20, weight: .light))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(text: "You have the opportunity to start a new chat", font: UIFont.systemFont(ofSize: 16, weight: .light))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(titel: "Accept", backgroundColor: .black, titleColor: .white, font: .laoSangamMN20(), cornerRadius: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(acceptButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var denyButton: UIButton = {
        let button = UIButton(titel: "Deny", backgroundColor: .mainWhite(), titleColor: #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1), font: .laoSangamMN20(), cornerRadius: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1.2
        button.layer.borderColor = #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1)
        button.addTarget(self, action: #selector(denyButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var activiteIndecatorToAcceptButton = UIActivityIndicatorView(hidenWhenStoped: true)
    private lazy var activiteIndecatorToDenyButton = UIActivityIndicatorView(hidenWhenStoped: true)
    
    private var currentChat: MChat
    
    weak var delegate: ChatRequestDelegate?
    
    init(currentChat: MChat) {
        self.currentChat = currentChat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        acceptButton.applyGradients(cornerRadius: 10)
    }
}

// MARK: - Private method
extension ChatRequestViewController {
    
    private func setupSubview() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        acceptButton.addSubview(activiteIndecatorToAcceptButton)
        denyButton.addSubview(activiteIndecatorToDenyButton)
        activiteIndecatorToAcceptButton.translatesAutoresizingMaskIntoConstraints = false
        activiteIndecatorToDenyButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        // Button Accept and Deny
        let stackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 8)
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Description activite indecator to accept button
        NSLayoutConstraint.activate([
            activiteIndecatorToAcceptButton.centerXAnchor.constraint(equalTo: acceptButton.centerXAnchor),
            activiteIndecatorToAcceptButton.centerYAnchor.constraint(equalTo: acceptButton.centerYAnchor)
        ])
        
        // Description activite indecator to deny button
        NSLayoutConstraint.activate([
            activiteIndecatorToDenyButton.centerXAnchor.constraint(equalTo: denyButton.centerXAnchor),
            activiteIndecatorToDenyButton.centerYAnchor.constraint(equalTo: denyButton.centerYAnchor)
        ])
        
    }
    
    
}


extension ChatRequestViewController {
    
    func config() {
        nameLabel.text = currentChat.username
        imageView.sd_setImage(with: URL(string: currentChat.userImageString))
    }
}


// MARK: - Objc method
extension ChatRequestViewController {
    @objc private func acceptButtonPress() {
        acceptButton.isEnabled = false
        denyButton.isEnabled = false
        activiteIndecatorToAcceptButton.startAnimating()
        delegate?.acceptWaitingChat(sender: currentChat)
    }
    
    @objc private func denyButtonPress() {
        acceptButton.isEnabled = false
        denyButton.isEnabled = false
        activiteIndecatorToDenyButton.startAnimating()
        delegate?.denyWaitingChat(senderID: currentChat.id)
    }
}

