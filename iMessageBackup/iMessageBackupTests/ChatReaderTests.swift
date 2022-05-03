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
    private var chatReaderMirroringContacts: ChatReader?
    private var chatReaderNoContacts: ChatReader?

    override func setUp() {
        
        do {
            self.inMemoryDb = try InMemoryChatDb()
            self.dbConnection = self.inMemoryDb?.connection
            if let connection = self.dbConnection {
                self.chatReaderMirroringContacts = ChatReader(db: connection, reversePhoneBook: MirroringPhoneBook())
                self.chatReaderNoContacts = ChatReader(db: connection, reversePhoneBook: EmptyPhoneBook())
            }
        } catch {
            XCTFail()
        }
        
        XCTAssertNotNil(self.inMemoryDb)
        XCTAssertNotNil(self.dbConnection)
        XCTAssertNotNil(self.chatReaderMirroringContacts)
    }
    
    // MARK: - metrics

    func testMetricsEmpty() throws {
        switch self.chatReaderNoContacts?.metrics {
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
        
        switch self.chatReaderNoContacts?.metrics {
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
        
        switch self.chatReaderNoContacts?.metrics {
        case .success(let result):
            XCTAssertEqual(result.numChats, 100)
            XCTAssertEqual(result.numMessages, 100)
        case .failure:
            XCTFail("Metrics call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }
    
    // MARK: - allChats

    func testAllChatsEmpty() throws {
        switch self.chatReaderNoContacts?.allChats {
        case .success(let result):
            XCTAssertEqual(result.count, 0)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testAllChats1() throws {
        
        try self.inMemoryDb?.insert(chat: Chat(id: 1, chatIdentifier: "person1@example.com", recipient: nil))
        
        switch self.chatReaderMirroringContacts?.allChats {
        case .success(let result):
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, 1)
            XCTAssertEqual(result.first?.chatIdentifier, "person1@example.com")
            XCTAssertEqual(result.first?.recipient?.lastName, "person1@example.com")
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testAllChats100() throws {
        
        try self.inMemoryDb?.insertChats(count: 100)

        switch self.chatReaderMirroringContacts?.allChats {
        case .success(let result):
            XCTAssertEqual(result.count, 100)

            XCTAssertEqual(result.first?.id, 1)
            XCTAssertEqual(result.first?.chatIdentifier, "person1@example.com")
            XCTAssertEqual(result.first?.recipient?.lastName, "person1@example.com")

            XCTAssertEqual(result.last?.id, 100)
            XCTAssertEqual(result.last?.chatIdentifier, "person100@example.com")
            XCTAssertEqual(result.last?.recipient?.lastName, "person100@example.com")
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testAllChatsUnknownContact1() throws {
        
        try self.inMemoryDb?.insert(chat: Chat(id: 1, chatIdentifier: "person1@example.com", recipient: nil))
        
        switch self.chatReaderNoContacts?.allChats {
        case .success(let result):
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.id, 1)
            XCTAssertEqual(result.first?.chatIdentifier, "person1@example.com")
            XCTAssertNil(result.first?.recipient)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testAllChatsUnknownContacts100() throws {
        
        try self.inMemoryDb?.insertChats(count: 100)

        switch self.chatReaderNoContacts?.allChats {
        case .success(let result):
            XCTAssertEqual(result.count, 100)
            
            XCTAssertEqual(result.first?.id, 1)
            XCTAssertEqual(result.first?.chatIdentifier, "person1@example.com")
            XCTAssertNil(result.first?.recipient)
            
            XCTAssertEqual(result.last?.id, 100)
            XCTAssertEqual(result.last?.chatIdentifier, "person100@example.com")
            XCTAssertNil(result.last?.recipient)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    // MARK: - allChatsWithKnownContacts
    
    func testallChatsWithKnownContactsUnknownContactsEmpty() throws {
        
        switch self.chatReaderNoContacts?.allChatsWithKnownContacts {
        case .success(let result):
            XCTAssertEqual(result.count, 0)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testallChatsWithKnownContactsUnknownContacts100() throws {
        
        try self.inMemoryDb?.insertChats(count: 100)

        switch self.chatReaderNoContacts?.allChatsWithKnownContacts {
        case .success(let result):
            XCTAssertEqual(result.count, 0)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testallChatsWithKnownContactsEmpty() throws {
        
        switch self.chatReaderMirroringContacts?.allChatsWithKnownContacts {
        case .success(let result):
            XCTAssertEqual(result.count, 0)
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

    func testallChatsWithKnownContacts100() throws {
        
        try self.inMemoryDb?.insertChats(count: 100)

        switch self.chatReaderMirroringContacts?.allChatsWithKnownContacts {
        case .success(let result):
            XCTAssertEqual(result.count, 100)

            XCTAssertEqual(result.first?.id, 1)
            XCTAssertEqual(result.first?.chatIdentifier, "person1@example.com")
            XCTAssertEqual(result.first?.recipient?.lastName, "person1@example.com")

            XCTAssertEqual(result.last?.id, 100)
            XCTAssertEqual(result.last?.chatIdentifier, "person100@example.com")
            XCTAssertEqual(result.last?.recipient?.lastName, "person100@example.com")
        case .failure:
            XCTFail("allChats call failed")
        case .none:
            XCTFail("Missing chat reader")
        }
    }

}
