//
//  MockDataRepository.swift
//  TelebuChatTests
//
//  Created by Ammad on 13/08/2021.
//

import Foundation
@testable import TelebuChat

class MockDataRepository {
    
    var shouldReturnError = false
    var isFetchMessageCalled = false
    var completedMessages = [Message]()
    var completeClosure: ((Result<[Message], Error>) -> ())!
    
    convenience init() {
        self.init(false)
    }
    
    init(_ shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    func fetchSuccess() {
        completeClosure(.success(completedMessages))
    }
    
    func fetchFail(error: Error) {
        completeClosure(.failure(error))
    }
    
    func reset(){
        shouldReturnError = false
        isFetchMessageCalled = false
    }
}

extension MockDataRepository: DataRepositoryProtocol {
    func initFetch(offSet: Int, complete completionHandler: @escaping (Result<[Message], Error>) -> Void) {
        isFetchMessageCalled = true
        completeClosure = completionHandler
    }
}

class MockDataGenerator {
    func mockMessageData() -> [Message] {
        let path = Bundle.main.path(forResource: "messages", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let messages = try decoder.decode([Message].self, from: data!)
            return messages
        } catch let err {
            print(err)
        }
       return []
    }
}
