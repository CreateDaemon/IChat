//
//  LogInViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let mainLabel = UILabel(text: "Welcome back!", font: .avenir26())
    private let loginLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    
    private let googleButtom = UIButton(titel: "Google", backgroundColor: .white, titleColor: .buttonDark(), isShadow: true)
    private let logInButtom = UIButton(titel: "Login", backgroundColor: .buttonDark(), titleColor: .mainWhite())
    private let signUpButtom = UIButton(titel: "Sign Up", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    
    private let emailTextField = OneLineTextField()
    private let passwordTextField = OneLineTextField()
    
    weak var delegate: AuthNavigashenDelegate?
    
    // MARK: - viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButtom.customGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
        addTargetButtons()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        print(#function)
    }
}

// MARK: - Private method
extension LogInViewController {
    
    private func setupConstraints() {
        
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
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
        
        let stackView = UIStackView(arrangedSubviews: [orLabel, emailStackView, passwordStackView, logInButtom], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logInButtom.translatesAutoresizingMaskIntoConstraints = false
        logInButtom.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
            footerStackView.topAnchor.constraint(equalTo: logInButtom.bottomAnchor, constant: 5),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func addTargetButtons() {
        logInButtom.addTarget(self, action: #selector(logInButtonPress), for: .touchUpInside)
        signUpButtom.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension LogInViewController {
    
    @objc private func logInButtonPress() {
        AuthService.shered.signIn(email: emailTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Completion", message: "Email: \(user.email ?? "none")")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonPress() {
        dismiss(animated: true) {
            self.delegate?.goToSignUp()
        }
    }
}
