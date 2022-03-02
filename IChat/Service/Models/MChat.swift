//
//  MChat.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import Foundation
import Firebase

struct MChat: Hashable, Codable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["userImageString"] = userImageString
        rep["lastMessage"] = lastMessage
        rep["id"] = id
        
        return rep
    }
    
    init?(data: MUser, lastMessage: String) {
        username = data.username
        userImageString = data.avatarStringURL
        self.lastMessage = lastMessage
        id = data.id
    }
    
    init?(data: [String: Any]) {
        guard
            let username = data["username"] as? String,
            let userImageString = data["userImageString"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let id = data["id"] as? String
        else { return nil }
        
        self.username = username
        self.userImageString = userImageString
        self.lastMessage = lastMessage
        self.id = id
    }
    
    init?(data: DocumentChange) {
        let data = data.document.data()
        
        guard
            let username = data["username"] as? String,
            let userImageString = data["userImageString"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let id = data["id"] as? String
        else { return nil }
        
        self.username = username
        self.userImageString = userImageString
        self.lastMessage = lastMessage
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}
