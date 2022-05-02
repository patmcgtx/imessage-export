//
//  ChatReaderTests.swift
//  iMessageBackupTests
//
//  Created by Patrick McGonigle on 5/1/22.
//

import XCTest
import SQLite
@testable import iMessageBackup

class ChatReaderTests: XCTestCase {
        
    func testMetricsEmpty() throws {
        
        let inMemoryDb = try InMemoryChatDb()

        guard let dbConnection = inMemoryDb.connection else {
            return XCTFail("Failed to get in-memory database connection")
        }
        
        let reader = ChatReader(db: dbConnection)
        
        switch reader.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 0)
            XCTAssertEqual(result.numMessages, 0)
        case .failure:
            XCTFail("Metrics call failed")
        }
    }

    func testMetrics1() throws {
        
        let inMemoryDb = try InMemoryChatDb()
        try inMemoryDb.insert(chat: Chat(id: 1, chatIdentifier: "person1@example.com", recipient: nil))
        try inMemoryDb.insert(message: Message(id: 1, text: "Message 1"))

        guard let dbConnection = inMemoryDb.connection else {
            return XCTFail("Failed to get in-memory database connection")
        }
        
        let reader = ChatReader(db: dbConnection)
        
        switch reader.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 1)
            XCTAssertEqual(result.numMessages, 1)
        case .failure:
            XCTFail("Metrics call failed")
        }
    }
    
    func testMetrics100() throws {
        
        let inMemoryDb = try InMemoryChatDb()
        try inMemoryDb.insertChats(count: 100)
        try inMemoryDb.insertMessages(count: 100)

        guard let dbConnection = inMemoryDb.connection else {
            return XCTFail("Failed to get in-memory database connection")
        }
        
        let reader = ChatReader(db: dbConnection)
        
        switch reader.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 100)
            XCTAssertEqual(result.numMessages, 100)
        case .failure:
            XCTFail("Metrics call failed")
        }
    }

}
