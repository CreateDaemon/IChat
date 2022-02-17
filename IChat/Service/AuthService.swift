//
//  AuthService.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import FirebaseAuth

class AuthService {
    
    static let shered = AuthService()
    private let auth = Auth.auth()
    
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
}
