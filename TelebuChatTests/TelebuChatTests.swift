//
//  TelebuChatTests.swift
//  TelebuChatTests
//
//  Created by Ammad on 12/08/2021.
//

import XCTest
@testable import TelebuChat

class TelebuChatTests: XCTestCase {
    var sut: CustomChatViewModel!
    var mockDataRepository: MockDataRepository!
    
    override func setUp() {
        super.setUp()
        mockDataRepository = MockDataRepository()
        sut = CustomChatViewModel(dataRepo: mockDataRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockDataRepository = nil
        super.tearDown()
    }
    
    func test_FetchMessages_FromDataRepository_Succeeds() {
        
        // Given
        mockDataRepository.completedMessages = [Message]()
        
        // When
        sut.initFetch(offSet: 0, isPagination: false)
        
        // Assert
        XCTAssert(mockDataRepository.isFetchMessageCalled)
    }
    
    func test_LoadingWhileFetching_Suceeds() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetch(offSet: 0, isPagination: false)
        
        // Assert
        XCTAssertTrue(loadingStatus)
        
        // When finished fetching
        mockDataRepository!.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_CreateCellViewModel_Succeeds() {
        
        // Given
        let expect = XCTestExpectation(description: "reload closure triggered")
        var messages = [Message]()
        sut.reloadTableViewClosure = { [weak self] () in
            expect.fulfill()
            messages = self?.sut.messages ?? []
        }
        
        // When
        sut.initFetch(offSet: 0, isPagination: false)
        mockDataRepository.fetchSuccess()
        
        // Number of cell view model is equal to the number of messages
        XCTAssertEqual(sut.numberOfRows, messages.count)
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
    }
}
