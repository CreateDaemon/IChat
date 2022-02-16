//
//  Bundel + Extension.swift
//  IChat
//
//  Created by Дмитрий Межевич on 11.02.22.
//

import Foundation

extension Bundle {

    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        let decode = JSONDecoder()

        guard let loaded = try? decode.decode(T.self, from: data) else {
            return nil
        }
        return loaded
    }
}


//extension Bundle {
//    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle.")
//        }
//
//        let decoder = JSONDecoder()
//
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle.")
//        }
//
//        return loaded
//    }
//}
