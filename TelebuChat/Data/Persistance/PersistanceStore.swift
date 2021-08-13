//
//  MessageRepository.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit
import CoreData

protocol PersistanceStore {
    func saveMessage(message: Message)
    func loadMessages(offSet: Int) -> [Message]?
}

struct MessagePersistanceStore: PersistanceStore {
    
    let context = PersistentStorage.shared.context
    
    func saveMessage(message: Message) {
        let cdMessage = CDMessage(context: context)
        cdMessage.message = message.message
        cdMessage.timeStamp = message.timeStamp
        cdMessage.userId = message.userId
        cdMessage.userName = message.userName
        PersistentStorage.shared.saveContext()
    }
    
    func loadMessages(offSet: Int) -> [Message]? {
        var messages: [Message] = []
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDMessage.self, offSet: offSet)
        
        result?.forEach({ (cdMessage) in
            messages.append(cdMessage.convertToMessage())
        })
        return messages
    }
}
