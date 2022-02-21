//
//  FirebaseSourvice.swift
//  IChat
//
//  Created by Дмитрий Межевич on 20.02.22.
//

import Firebase
import UIKit

class FirebaseSourvice {
    
    static let shered = FirebaseSourvice()
    let db = Firestore.firestore()
    private var docRef: CollectionReference {
        db.collection("users")
    }
    
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
        
        
        FirebaseStorage.shered.uploadAvatarImage(image: avatarImage) { result in
            switch result {
            case .success(let url):
                let user = MUser(username: username!,
                                 email: Auth.auth().currentUser!.email!,
                                 description: description!,
                                 avatarStringURL: url.absoluteString,
                                 sex: sex!,
                                 id: Auth.auth().currentUser!.uid)
                
                self.docRef.document(Auth.auth().currentUser!.uid).setData(user.representation) { err in
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
}
