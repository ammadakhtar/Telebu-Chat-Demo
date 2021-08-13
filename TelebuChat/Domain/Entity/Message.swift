//
//  Message.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import Foundation

struct Message: Decodable {
    var message: String?
    var userName: String?
    var userId: String?
    var timeStamp: String?
}
