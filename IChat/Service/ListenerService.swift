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
}
