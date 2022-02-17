//
//  ViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 7.02.22.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    private let googleLabel = UILabel(text: "Get started with")
    private let emailleLabel = UILabel(text: "Or sign up with")
    private let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    private let googleButton = UIButton(titel: "Google",
                                        backgroundColor: .white,
                                        titleColor: .buttonDark(),
                                        isShadow: true)
    @objc private let emailButton = UIButton(titel: "Email",
                                       backgroundColor: .black,
                                       titleColor: .white)
    private let loginButton = UIButton(titel: "Login",
                                       backgroundColor: .white,
                                       titleColor: .buttonRed(),
                                       isShadow: true)
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupConstraints()
        addTargetButtons()
    }
    
    
}

// MARK: - Private method
extension AuthViewController {
    
    private func setupConstraints() {
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
        ])
        
        let googleView = ButtonFromView(lable: googleLabel, button: googleButton)
        let emailView = ButtonFromView(lable: emailleLabel, button: emailButton)
        let loginView = ButtonFromView(lable: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func addTargetButtons() {
        emailButton.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension AuthViewController {
    
    @objc private func emailButtonPress() {
        present(SignUpViewController(), animated: true)
    }
    
    @objc private func loginButtonPress() {
        present(LogInViewController(), animated: true)
    }
}

