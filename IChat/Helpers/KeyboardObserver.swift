//
//  KeyboardObserver.swift
//  IChat
//
//  Created by Дмитрий Межевич on 30.03.22.
//

import Foundation
import UIKit

final class KeyboardObserver {
    
    private weak var viewController: UIViewController?
    private weak var lastViewInViewController: UIView?
    
    init(viewController: UIViewController, lastViewInViewController: UIView) {
        self.viewController = viewController
        self.lastViewInViewController = lastViewInViewController
    }
    
    func registerForKeybourdNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func cancelForKeybourdNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keybourdWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        guard let view = lastViewInViewController else { return }
        
        let offset = UIScreen.main.bounds.height - view.frame.maxY
        viewController?.view.frame.origin.y = -keyboardSize.height + offset
    }

    @objc
    private func keybourdWillHide(notification: NSNotification) {
        viewController?.view.frame.origin.y = 0
    }
}
