//
//  ProfileError.swift
//  IChat
//
//  Created by Дмитрий Межевич on 20.02.22.
//

import Foundation

enum ProfileError {
    case notFilled
    case photoNotExist
    case serviceError
    case dontHaveUID
    case notDocumentFile
    case errorTransformationInMUser
    case userNorFound
}

extension ProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполниете все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Выберите фото", comment: "")
        case .serviceError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .dontHaveUID:
            return NSLocalizedString("Отсуствует пользователь", comment: "")
        case .notDocumentFile:
            return NSLocalizedString("Отсуствует файл с личной информацией", comment: "")
        case .errorTransformationInMUser:
            return NSLocalizedString("Ошибка при преобразование данных в формат MUser", comment: "")
        case .userNorFound:
            return NSLocalizedString("Пользователь не найден", comment: "")
        }
    }
}
