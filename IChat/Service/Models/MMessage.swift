//
//  MMessage.swift
//  IChat
//
//  Created by Дмитрий Межевич on 23.02.22.
//

import Foundation
import Firebase
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Photo: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    
    var text: String? = nil
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    var kind: MessageKind {
        if let text = text, !text.isEmpty {
            return .text(text)
        } else if let image = image {
            let photo = Photo(url: nil,
                              image: nil,
                              placeholderImage: image,
                              size: image.size)
            return .photo(photo)
        } else {
            return .text("")
        }
    }
    
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["senderId": sender.senderId]
        rep["displayName"] = sender.displayName
        rep["messageId"] = messageId
        rep["sentDate"] = sentDate
        
        if let text = text {
            rep["text"] = text
        } else if let downloadURL = downloadURL {
            rep["downloadURL"] = downloadURL.absoluteString
        }
        
        return rep
    }
    
    init(user: MUser, text: String) {
        sender = Sender(senderId: user.id, displayName: user.username)
        messageId = UUID().uuidString
        sentDate = Date()
        self.text = text
    }
    
    init(user: MUser, downloadURL: URL) {
        sender = Sender(senderId: user.id, displayName: user.username)
        messageId = UUID().uuidString
        sentDate = Date()
        self.downloadURL = downloadURL
    }
    
    init?(document: QueryDocumentSnapshot) {
        let document = document.data()
        
        guard
            let senderId = document["senderId"] as? String,
            let displayName = document["displayName"] as? String,
            let messageId = document["messageId"] as? String,
            let sentDate = document["sentDate"] as? Timestamp
        else { return nil }
        
        if let text = document["text"] as? String {
            self.text = text
        } else if let downloadURLString = document["downloadURL"] as? String,
                  let downloadURL = URL(string: downloadURLString) {
            self.downloadURL = downloadURL
        }
        
        sender = Sender(senderId: senderId, displayName: displayName)
        self.messageId = messageId
        self.sentDate = sentDate.dateValue()
    }
}

extension MMessage: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        lhs.sentDate < rhs.sentDate
    }
}
