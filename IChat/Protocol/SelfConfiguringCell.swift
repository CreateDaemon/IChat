//
//  SelfConfiguringCell.swift
//  IChat
//
//  Created by Дмитрий Межевич on 16.02.22.
//

import Foundation


protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func updateCell(data: MChat)
}
