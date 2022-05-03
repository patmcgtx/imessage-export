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
        
    private var inMemoryDb: InMemoryChatDb?
    private var dbConnection: Connection?
    private var chatReader: ChatReader?
    
    override func setUp() {
        
        do {
            self.inMemoryDb = try InMemoryChatDb()
            self.dbConnection = self.inMemoryDb?.connection
            if let connection = self.dbConnection {
                self.chatReader = ChatReader(db: connection, reversePhoneBook: InMemoryContacts())
            }
        } catch {
            XCTFail()
        }
        
        XCTAssertNotNil(self.inMemoryDb)
        XCTAssertNotNil(self.dbConnection)
        XCTAssertNotNil(self.chatReader)
    }
    
    func testMetricsEmpty() throws {        
        switch self.chatReader?.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 0)
            XCTAssertEqual(result.numMessages, 0)
        case .failure:
            XCTFail("Metrics call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testMetrics1() throws {
        
        try self.inMemoryDb?.insert(chat: Chat(id: 1, chatIdentifier: "person1@example.com", recipient: nil))
        try self.inMemoryDb?.insert(message: Message(id: 1, text: "Message 1"))
        
        switch self.chatReader?.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 1)
            XCTAssertEqual(result.numMessages, 1)
        case .failure:
            XCTFail("Metrics call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }
    
    func testMetrics100() throws {
        
        try self.inMemoryDb?.insertChats(count: 100)
        try self.inMemoryDb?.insertMessages(count: 100)
        
        switch self.chatReader?.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 100)
            XCTAssertEqual(result.numMessages, 100)
        case .failure:
            XCTFail("Metrics call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

}
