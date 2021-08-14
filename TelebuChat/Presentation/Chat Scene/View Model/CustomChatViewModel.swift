//
//  CustomChatViewModel.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import Foundation

final class CustomChatViewModel {
    var messages = [Message]()
    private var dataRepo: DataRepositoryProtocol
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadTableViewClosure: (()->())?
    
    private var cellViewModels: [ChatCellUIModel] = [ChatCellUIModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    init(dataRepo:DataRepositoryProtocol = DataRepository()) {
        self.dataRepo = dataRepo
    }
    
    func initFetch(offSet: Int) {
        self.isLoading = true
        dataRepo.initFetch(offSet: offSet){ [weak self] result in
            self?.isLoading = false
            switch result{
            case .success(let messages):
                if messages.count > 0 {
                self?.processMessagesToCellModel(messages: messages)
                }
            case .failure(let error):
                self?.processError(error: error)
            }
        }
    }
    
    var numberOfRows: Int {
        return cellViewModels.count
    }
    
    private func processError(error:Error) {
        self.alertMessage = error.localizedDescription
    }
    
    private func processMessagesToCellModel(messages: [Message]) {
        let messagesData = messages.reversed()
        self.messages.insert(contentsOf: messagesData, at: 0)
        self.cellViewModels = self.messages.map { createCellViewModel(message: $0) }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ChatCellUIModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(message:Message) -> ChatCellUIModel {
        return ChatCellUIModel(message: message.message, userName: message.userName, timeStamp: message.timeStamp, userId: message.userId)
    }
}
