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
    private let activiteIndecator = UIActivityIndicatorView(hidenWhenStoped: true)
    
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
        cancelButton.addTarget(self, action: #selector(cancelButtonPress), for: .touchUpInside)
        goButton.addTarget(self, action: #selector(goButtonPress), for: .touchUpInside)
        choosePhoto.button.addTarget(self, action: #selector(choosePhotoButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension SetupProfileViewController {
    
    @objc private func goButtonPress() {
        activiteIndecator.startAnimating()
        FirebaseService.shered.saveNewUser(username: usernameTextField.text,
                                            description: aboutMeTextField.text,
                                            sex: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex),
                                            avatarImage: choosePhoto.photo.image!)
        { result in
            switch result {
            case .success(let user):
                self.activiteIndecator.stopAnimating()
                self.showAlert(title: "Completion", message: "Go to chat \(user.username)!")
                SceneDelegate.shared.rootViewController.goToMainTabBarController(user: user)
            case .failure(let error):
                self.activiteIndecator.stopAnimating()
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func cancelButtonPress() {
        activiteIndecator.startAnimating()
        AuthService.shered.SignOut { [unowned self] result in
            switch result {
            case .success:
                self.activiteIndecator.stopAnimating()
                SceneDelegate.shared.rootViewController.goToAuthViewController()
            case .failure(let error):
                self.activiteIndecator.stopAnimating()
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func choosePhotoButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

}

extension SetupProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        choosePhoto.photo.image = image
    }
}




