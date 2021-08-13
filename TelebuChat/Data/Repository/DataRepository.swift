//
//  DataRepository.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import Foundation

protocol DataRepositoryProtocol {
    func initFetch(offSet: Int, complete completion: @escaping (Result<[Message], Error>) -> Void)
}

final class DataRepository: DataRepositoryProtocol {
    
    private var persistanceStore: PersistanceStore?
    
    init(persistanceStore: PersistanceStore = MessagePersistanceStore()) {
        self.persistanceStore = persistanceStore
        saveLocalMessagesToDB()
    }
    // write transaction in coredata
    private func saveToDB(_ messages: [Message]) {
        messages.forEach { (message) in
            persistanceStore?.saveMessage(message: message)
        }
    }
    
    // read from coredata
    private func loadFromDB(offSet: Int, complete completion: @escaping (Result<[Message], Error>) -> Void) {
        let messages = persistanceStore?.loadMessages(offSet: offSet)
        completion(.success(messages ?? []))
    }
    
    func initFetch(offSet:Int, complete completion: @escaping (Result<[Message], Error>) -> Void) {
        // This provides abstraction to our viewModel layer that doesnt need to know if we are fetching from
        // an api service or a database
        // if we would have an api service we can inject that as a dependency above and load messages from there
        // incase of no internet we can load messages from database. For task since we dont have an apiService we
        // will use our dataBase to load messages
        loadFromDB(offSet: offSet) { result in
            completion(.success( try! result.get()))
        }
    }
    
    func saveLocalMessagesToDB() {
        // meesages.json is the local file used to add messages to app for demo purpose
        if let path = Bundle.main.path(forResource: "messages", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                do {
                    let messages = try decoder.decode([Message].self, from: data)
                    saveToDB(messages)
                } catch let err {
                    print("Error decoding json: \(err.localizedDescription)")
                }
            } catch (let error){
                print("Could not load file from bundle: \(error.localizedDescription)")
            }
        }
    }
}
