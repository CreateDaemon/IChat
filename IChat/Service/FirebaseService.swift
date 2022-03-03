//
//  FirebaseSourvice.swift
//  IChat
//
//  Created by Дмитрий Межевич on 20.02.22.
//

import Firebase
import UIKit
import FirebaseFirestore

class FirebaseService {
    
    static let shered = FirebaseService()
    
    private let db = Firestore.firestore()
    private var docRef: CollectionReference {
        db.collection("users")
    }
    private var currentUID: String {
        Auth.auth().currentUser!.uid
    }
    
    // MARK: - saveNewUser
    func saveNewUser(username: String?, description: String?, sex: String?, avatarImage: UIImage, comletiom: @escaping (Result<MUser, Error>) -> Void) {
        
        guard
            Validators.isFilled(username: username, description: description, sex: sex)
        else {
            comletiom(.failure(ProfileError.notFilled))
            return
        }
        
        guard
            Validators.checkAvatar(avatarImage: avatarImage)
        else {
            comletiom(.failure(ProfileError.photoNotExist))
            return
        }
        
        
        FirebaseStorage.shered.uploadAvatarImage(image: avatarImage) { [unowned self] result in
            switch result {
            case .success(let url):
                let user = MUser(username: username!,
                                 email: Auth.auth().currentUser!.email!,
                                 description: description!,
                                 avatarStringURL: url.absoluteString,
                                 sex: sex!,
                                 id: self.currentUID)
                
                self.docRef.document(self.currentUID).setData(user.representation) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        return
                    } else {
                        print("Document successfully written!")
                    }
                    comletiom(.success(user))
                }
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    // MARK: - get user data
    func getUserData(with uid: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard let uid = uid else {
            completion(.failure(ProfileError.dontHaveUID))
            return
        }
        
        let userRef = docRef.document(uid)
        userRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(ProfileError.serviceError))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(ProfileError.notDocumentFile))
                return
            }
            
            guard let user = MUser(data: document.data()) else {
                completion(.failure(ProfileError.errorTransformationInMUser))
                return
            }
            completion(.success(user))
        }
    }
    
    // MARK: - delete all messages to one and two user
    func deleteAllMessageInChat(senderID: String, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        
        let refWaitingChat = db.collection(["users", currentUID, "waitingChats"].joined(separator: "/")).document(senderID)
        let refActiveChatSender = db.collection(["users", senderID, "activeChats"].joined(separator: "/")).document(currentUID)
        
        deleteMessagesInChat(refChat: refWaitingChat) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.deleteMessagesInChat(refChat: refActiveChatSender) { result in
                    switch result {
                    case .success:
                        completion(.success(messages))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - delete all messages to one user
    func deleteMessages(senderID: String, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        
        let refWaitingChat = db.collection(["users", currentUID, "waitingChats"].joined(separator: "/")).document(senderID)
        
        deleteMessagesInChat(refChat: refWaitingChat) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - createActiveChat
    func createActiveChat(sender: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let refActiveChat = db.collection(["users", currentUID, "activeChats"].joined(separator: "/")).document(sender.id)
        
        deleteMessages(senderID: sender.id) { result in
            switch result {
            case .success(let messages):
                messages.forEach { message in
                    refActiveChat.collection("messages").addDocument(data: message.representation) { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                    }
                }
                refActiveChat.setData(sender.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    // MARK: - Checks if there is already an active chat with the receiver
    func chekcSenderHaveActiveChat(receiver: MUser, completion: @escaping (Result<MChat?, Error>) -> Void) {
        let documentRef = db.collection(["users", receiver.id, "activeChats"].joined(separator: "/"))
        
        documentRef.document(currentUID).getDocument { [unowned self] document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.success(nil))
                return
            }
            
            let receiverChatRef = self.db.collection(["users", self.currentUID, "activeChats"].joined(separator: "/"))
            receiverChatRef.document(receiver.id).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    completion(.success(nil))
                    return
                }
                
                guard
                    let data = document.data(),
                    let chat = MChat(data: data)
                else {
                    return
                }
                completion(.success(chat))
            }
        }
    }
    
    
}







// MARK: - Sending a Message
extension FirebaseService {
    
    func sendingMessage(from sender: MUser, to receiver: MUser, message: MMessage,completion: @escaping (Result<Void, Error>) -> Void) {
        // 1
        createReference(receiverId: receiver.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ref):
                // 2
                self.addSenderAndMessage(user: sender, message: message, reference: ref) { result in
                    switch result {
                    case .success:
                        // 3 Create active chat and add message to sneder
                        let currentUserActiveChatsRef = self.db.collection(["users", self.currentUID, "activeChats"].joined(separator: "/"))
                        self.addSenderAndMessage(user: receiver, message: message, reference: currentUserActiveChatsRef) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func sendMessageInChat(sender: MUser, chat: MChat, message: MMessage,completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection("users")
        
        ref.document(chat.id).getDocument { [unowned self] document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                return
            }
            
            guard let receiver = MUser(data: document.data()) else { return }
            sendingMessage(from: sender, to: receiver, message: message) { result in
                switch result {
                case .success():
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}










// MARK: - Helper methods
extension FirebaseService {
    
    // Create collection reference
    private func createReference(receiverId: String, completion: @escaping (Result<CollectionReference, Error>) -> Void) {
        let refActiveChat = db.collection(["users", receiverId, "activeChats"].joined(separator: "/"))
        let refWaitingChat = db.collection(["users", receiverId, "waitingChats"].joined(separator: "/"))
        
        refActiveChat.document(currentUID).getDocument { document, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                completion(.success(refActiveChat))
            } else {
                completion(.success(refWaitingChat))
            }
        }
    }
    
    
    // Add document with sender and add message in this document
    private func addSenderAndMessage(user: MUser, message: MMessage, reference: CollectionReference, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let chat = MChat(data: user, lastMessage: message.text ?? "") else { return }
        
        reference.document(user.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let messageCollectionRef = reference.document(user.id).collection("messages")
            messageCollectionRef.document(message.messageId).setData(message.representation) { erorr in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(Void()))
            }
        }
    }
    
    // Delete messager to one user
    private func deleteMessagesInChat(refChat: DocumentReference, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        
        var massages = [MMessage]()
        
        refChat.collection("messages").getDocuments { queryDocuments, error in
            guard let documents = queryDocuments?.documents else {
                completion(.failure(error!))
                return
            }
            
            documents.forEach { document in
                guard let message = MMessage(document: document) else { return }
                massages.append(message)
                document.reference.delete()
            }
            
            refChat.delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
            
            completion(.success(massages))
        }
    }
    
}
