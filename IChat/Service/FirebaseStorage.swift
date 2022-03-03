//
//  FirebaseStorage.swift
//  IChat
//
//  Created by Дмитрий Межевич on 21.02.22.
//

import FirebaseStorage
import Firebase
import UIKit


class FirebaseStorage {
    
    static let shered = FirebaseStorage()
    
    private let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        storageRef.child("avatars")
    }
    
    private var currentUID: String {
        Auth.auth().currentUser!.uid
    }
    
    func uploadAvatarImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void ) {
        
        guard
            let scaleImage = image.scaledToSafeUploadSize,
            let imageData = scaleImage.jpegData(compressionQuality: 0.4)
        else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUID).putData(imageData, metadata: metadata) { [unowned self] metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(currentUID).downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(url))
            }
        }
    }
    
    func uplaodImageMessage(image: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard
            let scaleImage = image.scaledToSafeUploadSize,
            let imageData = scaleImage.jpegData(compressionQuality: 0.4)
        else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageMessageRef = storageRef.child("chats")
        let idImage = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let currentUser = Auth.auth().currentUser!.uid
        let receiverUser = chat.id
        let chatName = [currentUser, receiverUser].joined()
        
        imageMessageRef.child(chatName).child(idImage).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            imageMessageRef.child(chatName).child(idImage).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func downlaodImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let size: Int64 = 1 * 1024 * 1024
        ref.getData(maxSize: size) { data, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(UIImage(data: data)))
        }
    }
}
