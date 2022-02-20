//
//  SceneDelegate.swift
//  IChat
//
//  Created by Дмитрий Межевич on 7.02.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
    }


}

extension SceneDelegate {
    
    static var shared: SceneDelegate {
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { fatalError() }
        return delegate
    }
    
    var rootViewController: RootViewController {
          return window!.rootViewController as! RootViewController
       }
}

