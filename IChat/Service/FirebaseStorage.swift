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
}
