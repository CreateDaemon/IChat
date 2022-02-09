//
//  SignUpViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Elements of interface
    let mainLabel = UILabel(text: "Goot to see you!", font: .avenir26())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "ConfirmPassword")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let emailTextField = OneLineTextField()
    let passwordTextField = OneLineTextField()
    let confirmPasswordTextField = OneLineTextField()
    
    let signInButton = UIButton(titel: "Sign Up", backgroundColor: .buttonDark(), titleColor: .white)
    let loginButton = UIButton(titel: "Login", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
    }
    
}

// MARK: - Private method
extension SignUpViewController {
    
    private func setupConstraints() {
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
        ])
        
        
        let emailSteckView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordSteckView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let confirmPasswordSteckView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let stackView = UIStackView(arrangedSubviews: [emailSteckView, passwordSteckView, confirmPasswordSteckView, signInButton], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let footerStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 10)
        footerStackView.alignment = .firstBaseline
        loginButton.contentHorizontalAlignment = .leading
        view.addSubview(footerStackView)
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - PreviewProvider

import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SignUpViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}


