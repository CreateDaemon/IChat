//
//  MUser.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import Foundation

struct MUser: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var id: Int
    
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
