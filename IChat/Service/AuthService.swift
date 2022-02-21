//
//  AuthService.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import Firebase
import GoogleSignIn

class AuthService {
    
    static let shered = AuthService()
    private let auth = Auth.auth()
    
    // MARK: - signUp
    func signUp(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard
            Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword)
        else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard
            Validators.isValidEmail(email!)
        else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        guard
            password == confirmPassword
        else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
     
    // MARK: - sigIn
    func signIn(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard
            let email = email,
            let password = password,
            !email.isEmpty,
            !password.isEmpty
        else {
            completion(.failure(AuthError.notFilled))
            return
        }

        guard
            Validators.isValidEmail(email)
        else {
            completion(.failure(AuthError.invalidEmail))
            return
        }

        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func signInWithGoogle(viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(AuthError.cancel))
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion(.success(user!.user))
            }
        }
    }
    
    func SignOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard auth.currentUser != nil else {
            completion(.failure(ProfileError.userNorFound))
            return
        }
        do {
            try auth.signOut()
        } catch let error {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
}


