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
            let idColumn = Expression<Int>("ROWID")
            let guidColumn = Expression<String>("guid")

            // Create the chats table
            let chatsTable = Table("chat")
            
            try db?.run(chatsTable.create { table in
                table.column(idColumn, primaryKey: true)
                table.column(guidColumn, unique: true)
            })

            // Create the messages table
            let messagesTable = Table("message")
            let textColumn = Expression<String>("text")

            try db?.run(messagesTable.create { table in
                table.column(idColumn, primaryKey: true)
                table.column(guidColumn, unique: true)
                table.column(textColumn)
            })

            // TODO patmcg split out db creation and data pop
            try db?.run(chatsTable.insert(idColumn <- 0, guidColumn <- "chat0"))
            try db?.run(chatsTable.insert(idColumn <- 1, guidColumn <- "chat1"))
            try db?.run(chatsTable.insert(idColumn <- 2, guidColumn <- "chat2"))
            
            try db?.run(messagesTable.insert(idColumn <- 0, guidColumn <- "message0", textColumn <- "Message 0"))
            try db?.run(messagesTable.insert(idColumn <- 1, guidColumn <- "message1", textColumn <- "Message 1"))
            try db?.run(messagesTable.insert(idColumn <- 2, guidColumn <- "message2", textColumn <- "Message 2"))
            
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
