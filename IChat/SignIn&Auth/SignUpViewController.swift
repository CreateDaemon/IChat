//
//  SignUpViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 8.02.22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let mainLabel = UILabel(text: "Goot to see you!", font: .avenir26())
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let confirmPasswordLabel = UILabel(text: "ConfirmPassword")
    private let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    private let emailTextField = OneLineTextField()
    private let passwordTextField = OneLineTextField()
    private let confirmPasswordTextField = OneLineTextField()
    
    private let signUpButton = UIButton(titel: "Sign Up", backgroundColor: .buttonDark(), titleColor: .white)
    private let logInButton = UIButton(titel: "Login", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    private let backButton = UIButton(titel: "Go to back", backgroundColor: .clear, titleColor: .buttonDark(), cornerRadius: 0)
    
    private var keyboardObtherver: KeyboardObserver?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        settingDelegateAndObserver()
        setupConstraints()
        addTargetButtons()
    }
    
    deinit {
        keyboardObtherver?.cancelForKeybourdNotification()
    }
    
}

// MARK: - Private method
extension SignUpViewController {
    
    private func settingDelegateAndObserver() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        keyboardObtherver = KeyboardObserver(viewController: self, lastViewInViewController: backButton)
        
        keyboardObtherver?.registerForKeybourdNotification()
    }
    
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
        let stackView = UIStackView(arrangedSubviews: [emailSteckView, passwordSteckView, confirmPasswordSteckView, signUpButton], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let footerStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, logInButton], axis: .horizontal, spacing: 10)
        footerStackView.alignment = .firstBaseline
        logInButton.contentHorizontalAlignment = .leading
        view.addSubview(footerStackView)
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: footerStackView.bottomAnchor)
        ])
    }
    
    private func addTargetButtons() {
        signUpButton.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInButtonPress), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension SignUpViewController {
    
    @objc private func signUpButtonPress() {
        
        AuthService.shered.signUp(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { result in
            switch result {
            case .success(let user):
                FirebaseService.shered.getUserData(with: user.uid) { result in
                    self.showAlert(title: "Completion", message: "Email: \(user.email ?? "none")")
                    switch result {
                    case .success(let user):
                        SceneDelegate.shared.rootViewController.goToMainTabBarController(user: user)
                    case .failure:
                        SceneDelegate.shared.rootViewController.goToSetupProfileViewController()
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func logInButtonPress() {
        SceneDelegate.shared.rootViewController.goToLogInViewController()
    }
    
    @objc private func backButtonPress() {
        SceneDelegate.shared.rootViewController.goToAuthViewController()
    }
    
}


// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - Override function
extension SignUpViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}


