//
//  MMessage.swift
//  IChat
//
//  Created by Дмитрий Межевич on 23.02.22.
//

import Foundation
import Firebase

struct MMessage: Hashable, Decodable {
    var content: String
    var senderId: String
    var senderUsername: String
    var senderDate: Date
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["content": content]
        rep["senderId"] = senderId
        rep["senderUsername"] = senderUsername
        rep["senderDate"] = senderDate
        
        return rep
    }
    
    init?(data: MUser, lastMessage: String) {
        content = lastMessage
        senderId = data.id
        senderUsername = data.username
        senderDate = Date()
    }
    
    init?(data: [String: Any]) {
        guard
            let content = data["content"] as? String,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderUsername"] as? String,
            let senderDate = data["senderDate"] as? Timestamp
        else { return nil }
        
        self.content = content
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.senderDate = senderDate.dateValue()
    }
    
    init?(data: DocumentChange) {
        let data = data.document.data()
        
        guard
            let content = data["content"] as? String,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderUsername"] as? String,
            let senderDate = data["senderDate"] as? Date
        else { return nil }
        
        self.content = content
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.senderDate = senderDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(senderId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.senderId == rhs.senderId
    }
}
