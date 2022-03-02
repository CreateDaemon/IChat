//
//  ChatRequestDelegate.swift
//  IChat
//
//  Created by Дмитрий Межевич on 28.02.22.
//

import Foundation

protocol ChatRequestDelegate: AnyObject {
    func acceptWaitingChat(sender: MChat)
    func denyWaitingChat(senderID: String)
}
