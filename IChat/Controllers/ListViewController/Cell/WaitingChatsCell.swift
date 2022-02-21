//
//  WaitingChatsCell.swift
//  IChat
//
//  Created by Дмитрий Межевич on 15.02.22.
//

import UIKit

class WaitingChatsCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let reuseId = "waitingChats"
    
    private var userImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "human4")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
}

extension WaitingChatsCell {
    
    func updateCell<U>(data: U) where U : Hashable {
        guard let data = data as? MChat else { fatalError() }
        userImage.image = UIImage(named: data.userImageString)
    }
    
    private func setupConstraints() {
        addSubview(userImage)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 88),
            userImage.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}



// MARK: - PreviewProvider

//import SwiftUI
//
//struct WaitingChatsProvider: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContainerView().edgesIgnoringSafeArea(.all)
//        }
//    }
//    
//    struct ContainerView: UIViewControllerRepresentable {
//        
//        let viewController = MainTabBarController()
//        
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return viewController
//        }
//        
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//            
//        }
//    }
//}
