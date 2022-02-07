//
//  ViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 7.02.22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }


}


// MARK: - PreviewProvider

import SwiftUI

struct viewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = ViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

