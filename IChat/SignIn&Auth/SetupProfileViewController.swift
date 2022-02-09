//
//  SetupProfileViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit


class SetupProfileViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let maiLabel = UILabel(text: "Set up profile!", font: .avenir26())
    private let fullNameLabel = UILabel(text: "Full name")
    private let aboutMeLabel = UILabel(text: "About me")
    private let sexLabel = UILabel(text: "Sex")
    
    private let goButton = UIButton(titel: "Go to chats!",
                                    backgroundColor: .buttonDark(),
                                    titleColor: .buttonWhite())
    
    private let fullNameTextField = OneLineTextField()
    private let aboutMeTextField = OneLineTextField()
    
    private let choosePhoto = ChoosePhotoView()
    
    private let segmentedControl = UISegmentedControl(first: "Male", second: "Femail")
    
    // MARK: - viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstaints()
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
        
        let nameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField],
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

