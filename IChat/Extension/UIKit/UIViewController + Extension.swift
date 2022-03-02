//
//  UIViewController + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import UIKit

extension UIViewController {
    
    func configureCell<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError() }
        cell.updateCell(data: value)
        return cell
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(actionButton)
        
        present(alert, animated: true)
    }
    
    func showAlertWithCancel(title: String, message: String, titleOkButton: String, titleCancelButton: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: titleOkButton, style: .default) { _ in
            completion(true)
        }
        let actionCancelButton = UIAlertAction(title: titleCancelButton, style: .destructive)
        
        alert.addAction(actionButton)
        alert.addAction(actionCancelButton)
        
        present(alert, animated: true)
    }
}

