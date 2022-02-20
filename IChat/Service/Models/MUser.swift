//
//  MUser.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import Foundation

struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var description: String
    var avatarStringURL: String
    var sex: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["description"] = description
        rep["avatarStringURL"] = avatarStringURL
        rep["sex"] = sex
        rep["id"] = id
        return rep
    }
    
    init(username: String, email: String, description: String, avatarStringURL: String, sex: String, id: String) {
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    init?(data: [String: Any]?) {
        guard let data = data else { return nil }
        guard
            let username = data["username"] as? String,
            let email = data["email"] as? String,
            let avatarStringURL = data["avatarStringURL"] as? String,
            let description = data["description"] as? String,
            let sex = data["sex"] as? String,
            let id = data["id"] as? String
        else {
            return nil
        }
        
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter,
              !filter.isEmpty
        else { return true }
        let lowercasedText = filter.lowercased()
        return username.lowercased().contains(lowercasedText)
    }
}
