//
//  SetupProfileViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit
import Firebase

class SetupProfileViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let maiLabel = UILabel(text: "Set up profile!", font: .avenir26())
    private let fullNameLabel = UILabel(text: "User name")
    private let aboutMeLabel = UILabel(text: "About me")
    private let sexLabel = UILabel(text: "Sex")
    
    private let goButton = UIButton(titel: "Go to chats!",
                                    backgroundColor: .buttonDark(),
                                    titleColor: .mainWhite())
    private let cancelButton = UIButton(titel: "Cancel registration", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    
    private let usernameTextField = OneLineTextField()
    private let aboutMeTextField = OneLineTextField()
    
    private let choosePhoto = ChoosePhotoView()
    
    private let segmentedControl = UISegmentedControl(first: "Male", second: "Femail")
    
    // MARK: - viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstaints()
        addTargetButtons()
    }
}

// MARK: - Private method
extension SetupProfileViewController {
    private func setupConstaints() {
        
        view.addSubview(maiLabel)
        maiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            maiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(choosePhoto)
        choosePhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            choosePhoto.centerXAnchor.constraint(equalTo: maiLabel.centerXAnchor),
            choosePhoto.topAnchor.constraint(equalTo: maiLabel.bottomAnchor, constant: 30)
        ])
        
        let nameStackView = UIStackView(arrangedSubviews: [fullNameLabel, usernameTextField],
                                        axis: .vertical,
                                        spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField],
                                        axis: .vertical,
                                        spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, segmentedControl],
                                        axis: .vertical,
                                        spacing: 0)
        let stackView = UIStackView(arrangedSubviews: [nameStackView, aboutMeStackView, sexStackView, goButton],
                                    axis: .vertical,
                                    spacing: 40)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: choosePhoto.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cancelButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
    }
    
    private func addTargetButtons() {
        cancelButton.addTarget(self, action: #selector(cancelButtonPress), for: .touchUpInside)
        goButton.addTarget(self, action: #selector(goButtonPress), for: .touchUpInside)
    }
}


// MARK: - PreviewProvider

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}


// MARK: - @objc method
extension SetupProfileViewController {
    
    @objc private func goButtonPress() {
        FirebaseSourvice.shered.saveNewUser(username: usernameTextField.text,
                                            description: aboutMeTextField.text,
                                            sex: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex),
                                            avatarStringURL: "qwe")
        { result in
            switch result {
            case .success(let user):
                self.showAlert(title: "Completion", message: "Go to chat \(user.username)!")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        SceneDelegate.shared.rootViewController.goToMainTabBarController()
    }
    
    @objc private func cancelButtonPress() {
        
        do {
            try Auth.auth().signOut()
            SceneDelegate.shared.rootViewController.goToAuthViewController()
        } catch let error {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }

}




