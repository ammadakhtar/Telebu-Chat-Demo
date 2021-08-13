//
//  CDMessage+CoreDataProperties.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//
//

import Foundation
import CoreData


extension CDMessage {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMessage> {
        return NSFetchRequest<CDMessage>(entityName: "CDMessage")
    }
    @NSManaged public var message: String?
    @NSManaged public var timeStamp: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
}

extension CDMessage: Identifiable {
    func convertToMessage() -> Message {
        return Message(message: self.message, userName: self.userName, userId: self.userId, timeStamp: self.timeStamp)
    }
}
