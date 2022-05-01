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

    private var populatedInMemoryDb: Connection? {
        
        var db: Connection? = nil
        
        do {
            // In-memory database
            db = try Connection()

            // Common columns
            let rowId = Expression<Int>("ROWID")
            let guid = Expression<String>("guid")

            // Create the chats table
            let chats = Table("chat")
            
            try db?.run(chats.create { table in
                table.column(rowId, primaryKey: true)
                table.column(guid, unique: true)
            })

            // Create the messages table
            let messages = Table("message")
            let textColumn = Expression<String>("text")

            try db?.run(messages.create { table in
                table.column(rowId, primaryKey: true)
                table.column(guid, unique: true)
                table.column(textColumn)
            })

            // TODO patmcg split out db creation and data pop
            try db?.run(chats.insert(rowId <- 0, guid <- "chat0"))
            try db?.run(chats.insert(rowId <- 1, guid <- "chat1"))
            try db?.run(chats.insert(rowId <- 2, guid <- "chat2"))
            
            try db?.run(messages.insert(rowId <- 0, guid <- "message0", textColumn <- "Message 0"))
            try db?.run(messages.insert(rowId <- 1, guid <- "message1", textColumn <- "Message 1"))
            try db?.run(messages.insert(rowId <- 2, guid <- "message2", textColumn <- "Message 2"))
            
        } catch {
            XCTFail("Failed to create in-memory database")
        }
        
        return db
    }
    
    func testMetrics() throws {
        
        guard let db = self.populatedInMemoryDb else {
            return XCTFail("Failed to get populated in-memory database")
        }
        
        let reader = ChatReader(db: db)
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
