//
//  AuthError.swift
//  IChat
//
//  Created by Дмитрий Межевич on 17.02.22.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownedError
    case serverError
    case cancel
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполниете все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Не правильна почта", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Не правильный пароль", comment: "")
        case .unknownedError:
            return NSLocalizedString("Не известная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .cancel:
            return NSLocalizedString("Отмена действия", comment: "")
        }
    }
}
