//
//  ListenerService.swift
//  IChat
//
//  Created by Дмитрий Межевич on 22.02.22.
//


import Firebase
import FirebaseFirestore


class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    private var docRef: CollectionReference {
        db.collection("users")
    }
    private var currentUID: String {
        Auth.auth().currentUser!.uid
    }
    
    
    func addListener(users: [MUser], completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration {
        var users = users
        let listener = docRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let user = MUser(data: diff) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(user) else { return }
                    guard user.id != self.currentUID else { return }
                    users.append(user)
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return listener
    }
    
    
    func addListenerWaitingChats(waitingChats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration {
        var chats = waitingChats
        let listener = db.collection(["users", currentUID, "waitingChats"].joined(separator: "/")).addSnapshotListener {querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let chat = MChat(data: diff) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return listener
    }
    
    func addListenerActiveChats(activeChats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration {
        var chats = activeChats
        let listener = db.collection(["users", currentUID, "activeChats"].joined(separator: "/")).addSnapshotListener {querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let chat = MChat(data: diff) else { return }
                switch diff.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return listener
    }
    
    func addListenerMessages(chat: MChat, completion: @escaping (Result<MMessage, Error>) -> Void) -> ListenerRegistration {
        let ref = db.collection(["users", currentUID, "activeChats", chat.id, "messages"].joined(separator: "/"))
        
        let listener = ref.addSnapshotListener {querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let message = MMessage(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return listener
    }
    
    
}
