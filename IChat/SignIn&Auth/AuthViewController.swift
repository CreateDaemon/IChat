//
//  ViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 7.02.22.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let activiteIndecator = UIActivityIndicatorView(hidenWhenStoped: true)
    
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
    
    private let loginVC = LogInViewController()
    private let signUpVC = SignUpViewController()
    
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
        
        view.addSubview(activiteIndecator)
        activiteIndecator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activiteIndecator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activiteIndecator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activiteIndecator.heightAnchor.constraint(equalToConstant: 90),
            activiteIndecator.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func addTargetButtons() {
        googleButton.addTarget(self, action: #selector(googleButtonPress), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension AuthViewController {
    
    @objc private func googleButtonPress() {
        activiteIndecator.startAnimating()
        AuthService.shered.signInWithGoogle(viewController: self) { [unowned self] result in
            switch result {
            case .success(let user):
                FirebaseService.shered.getUserData(with: user.uid) { result in
                    switch result {
                    case .success(let user):
                        activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToMainTabBarController(user: user)
                    case .failure:
                        activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToSetupProfileViewController()
                    }
                }
            case .failure:
                activiteIndecator.stopAnimating()
            }
        }
    }
    
    @objc private func emailButtonPress() {
        SceneDelegate.shared.rootViewController.goToSignUpViewController()
    }
    
    @objc private func loginButtonPress() {
        SceneDelegate.shared.rootViewController.goToLogInViewController()
    }
}

