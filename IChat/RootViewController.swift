//
//  RootViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 19.02.22.
//

import UIKit
import Firebase

class RootViewController: UIViewController {
    
    private var current: UIViewController!
    
    private lazy var previewImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageLoad()
        
        setupStartViewController()
    }
}

// MARK: - Navigation method
extension RootViewController {
    
    func goToSignUpViewController() {
        let new = SignUpViewController()
        sliderTransition(to: new, start: CGPoint(x: -view.bounds.width, y: view.bounds.height))
    }
    
    func goToLogInViewController() {
        let new = LogInViewController()
        sliderTransition(to: new, start: CGPoint(x: view.bounds.width, y: view.bounds.height))
    }
    
    func goToAuthViewController() {
        let new = AuthViewController()
        sliderTransition(to: new, start: CGPoint(x: 0, y: -view.bounds.height))
    }
    
    func goToSetupProfileViewController() {
        let new = SetupProfileViewController()
        sliderTransition(to: new, start: CGPoint(x: view.bounds.width, y: 0))
    }
    
    func goToMainTabBarController() {
        let new = MainTabBarController()
        sliderTransition(to: new, start: CGPoint(x: view.bounds.width, y: 0))
    }
}

// MARK: - Private method
extension RootViewController {
    
    private func setImageLoad() {
        view.backgroundColor = .white
        view.addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupStartViewController() {
        guard let currentUser = Auth.auth().currentUser else {
            setupRootViewController(with: AuthViewController())
            return
        }
        
        FirebaseSourvice.shered.getUserData(with: currentUser.uid) { [unowned self] result in
            switch result {
            case .failure:
                self.setupRootViewController(with: SetupProfileViewController())
            case .success:
                self.setupRootViewController(with: MainTabBarController())
            }
        }
    }
    
    private func setupRootViewController(with viewController: UIViewController) {
        current = viewController
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

// MARK: - Animation transition
extension RootViewController {
    
    private func sliderTransition(to new: UIViewController, start point: CGPoint, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: point.x,
                                y: point.y,
                                width: view.bounds.width,
                                height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.5, options: [.curveEaseInOut]) {
            new.view.frame = self.view.bounds
        } completion: { completed in
            self.current.view.removeFromSuperview()
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }

        
    }
}
