//
//  UserDefaultsService.swift
//  IChat
//
//  Created by Дмитрий Межевич on 24.02.22.
//

import Foundation

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    func addWatingChats(chats: [MChat]) {
        DispatchQueue.main.async {
            guard let object = try? PropertyListEncoder().encode(chats) else { return }
            UserDefaults.standard.set(object, forKey: "waitingChats")
        }
    }
    
    func getWatingChats() -> [MChat] {
        guard
            let object = UserDefaults.standard.data(forKey: "waitingChats"),
            let chats = try? PropertyListDecoder().decode([MChat].self, from: object)
        else { return [] }
        return chats
    }
    
    func deleteWaitingChat() {
        UserDefaults.standard.removeObject(forKey: "waitingChats")
    }
    
    func updateWaitingChat(chats: [MChat]) {
        deleteWaitingChat()
        addWatingChats(chats: chats)
    }
    
    func deleteChats() {
        UserDefaults.standard.removeObject(forKey: "waitingChats")
        UserDefaults.standard.removeObject(forKey: "activeChats")
    }
}
