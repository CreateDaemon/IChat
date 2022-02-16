//
//  MainTabBarController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - viewDidLaod()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarControllers()
    }
}


// MARK: - Private method
extension MainTabBarController {
    
    private func setupTabBarControllers() {
        let listViewControlle = ListViewController()
        let peopleViewController = PeopleViewController()
        
        tabBar.tintColor = #colorLiteral(red: 0.629904747, green: 0.4648939967, blue: 0.9760698676, alpha: 1)
        let boldConfigImage = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfigImage)!
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfigImage)!
        
        viewControllers = [
            setupNavigationBar(rootViewController: listViewControlle,
                               title: "Conversations",
                               image: convImage),
            setupNavigationBar(rootViewController: peopleViewController,
                               title: "People",
                               image: peopleImage)
        ]
        
        let appearanceTabBar = UITabBarAppearance()
        appearanceTabBar.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance = appearanceTabBar
        tabBar.standardAppearance = appearanceTabBar
        
//        let appearanceNavBar = UINavigationBarAppearance()
//        appearanceNavBar.configureWithOpaqueBackground()
//        UINavigationBar.appearance().standardAppearance = appearanceNavBar
//        UINavigationBar.appearance().scrollEdgeAppearance = appearanceNavBar
    }
    
    
    
    private func setupNavigationBar(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navBar = UINavigationController(rootViewController: rootViewController)
        navBar.tabBarItem.title = title
        navBar.tabBarItem.image = image
        return navBar
    }
}
