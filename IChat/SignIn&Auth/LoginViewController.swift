//
//  LoginViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let mainLabel = UILabel(text: "Welcome back!", font: .avenir26())
    private let loginLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    
    private let googleButtom = UIButton(titel: "Google", backgroundColor: .white, titleColor: .buttonDark(), isShadow: true)
    private let loginButtom = UIButton(titel: "Login", backgroundColor: .buttonDark(), titleColor: .buttonWhite())
    private let signUpButtom = UIButton(titel: "Sign Up", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    
    private let emailTextField = OneLineTextField()
    private let passwordTextField = OneLineTextField()
    
    // MARK: - viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButtom.customGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
    }
}

// MARK: - Private method
extension LoginViewController {
    
    private func setupConstraints() {
        
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
        ])
        
        let googleStackView = UIStackView(arrangedSubviews: [loginLabel, googleButtom], axis: .vertical, spacing: 15)
        googleButtom.translatesAutoresizingMaskIntoConstraints = false
        googleButtom.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(googleStackView)
        googleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 100),
            googleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        let stackView = UIStackView(arrangedSubviews: [orLabel, emailStackView, passwordStackView, loginButtom], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        loginButtom.translatesAutoresizingMaskIntoConstraints = false
        loginButtom.heightAnchor.constraint(equalToConstant: 60).isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: googleStackView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let footerStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButtom], axis: .horizontal, spacing: 10)
        view.addSubview(footerStackView)
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpButtom.contentHorizontalAlignment = .leading
        footerStackView.alignment = .firstBaseline
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: loginButtom.bottomAnchor, constant: 5),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - PreviewProvider

import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
