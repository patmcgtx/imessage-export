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

    private var populatedInMemoryDb: InMemoryChatDb? {
        
        var inMemoryDb: InMemoryChatDb? = nil
        
        do {
            inMemoryDb = try InMemoryChatDb()

            try inMemoryDb?.insert(chat: Chat(id: 0, guid: "chat0"))
            try inMemoryDb?.insert(chat: Chat(id: 1, guid: "chat1"))
            try inMemoryDb?.insert(chat: Chat(id: 2, guid: "chat2"))
            
            try inMemoryDb?.insert(message: Message(id: 0, guid: "message0)", text: "Message 0"))
            try inMemoryDb?.insert(message: Message(id: 1, guid: "message1)", text: "Message 1"))
            try inMemoryDb?.insert(message: Message(id: 2, guid: "message2)", text: "Message 2"))
            
        } catch {
            XCTFail("In-memory database error: \(error.localizedDescription)")
        }
        
        return inMemoryDb
    }
    
    func testMetrics() throws {
        
        guard let inMemoryDb = self.populatedInMemoryDb else {
            return XCTFail("Failed to get in-memory database")
        }

        guard let dbConnection = inMemoryDb.connection else {
            return XCTFail("Failed to get in-memory database connection")
        }

        let reader = ChatReader(db: dbConnection)
        let metrics = reader.metrics
        
        switch metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 3)
            XCTAssertEqual(result.numMessages, 3)
        case .failure:
            XCTFail("Metrics call failed")
        }
    }

}
