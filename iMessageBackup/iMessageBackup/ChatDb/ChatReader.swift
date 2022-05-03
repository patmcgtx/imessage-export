//
//  ChatReader.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import SQLite

/// Reads a chat database and supplies information about it.
struct ChatReader {
    
    private var db: Connection?
    private let chatTable = ChatSchema.ChatTable()
    private let messageTable = ChatSchema.MessageTable()
    private let reversePhoneBook: ReversePhoneBook = AppleContacts() // TODO patmcg consider DI

    /**
     Creates a chat database reader for the given database path.
     - Parameter dbPath: A path to the chat database.
     - Returns: A chat reader instance _or_ `nil` if the database can't be read.
     */
    init?(dbPath: String) {
        do {
            self.db = try Connection(dbPath, readonly: true)
        } catch {
            return nil
        }
    }
    
    /// Creates a chat reader for the given database connection
    init(db: Connection) {
        self.db = db
    }
    
    /// Counts metrics from the chat database.
    var metrics: Swift.Result<ChatMetrics, Error> {
        do {
            let numChats = try self.db?.scalar(self.chatTable.sqliteTable.select(self.chatTable.idColumn.count)) ?? -1
            let numMessages = try self.db?.scalar(self.messageTable.sqliteTable.select(self.messageTable.idColumn.count)) ?? -1
            return .success(ChatMetrics(numChats: numChats, numMessages: numMessages))
        } catch {
            return .failure(error)
        }
    }
    
    // TODO patmcg make this async
    // TODO patmcg make this throws
    /// Gets all the chats in the database
    var allChats: Swift.Result<[Chat], Error> {
        
        var result = [Chat]()
        
        if let database = self.db {
            do {
                let rowIterator = try database.prepareRowIterator(self.chatTable.sqliteTable)
                for chatRow in try Array(rowIterator) {
                    let chatIdentifier = chatRow[self.chatTable.chatIdentifierColumn]
                    let chat = Chat(id: chatRow[self.chatTable.idColumn], chatIdentifier: chatIdentifier,
                                    recipient: self.reversePhoneBook.findPerson(byIdentifier: chatIdentifier))
                    result.append(chat)
                    print(chat.debugDescription)
                }
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(DbError.noDatabase)
        }
        
        return .success(result)
    }

    // TODO patmcg make this async
    // TODO patmcg make this throws
    /// Gets all the chats with known contact
    var allChatsWithKnownContacts: Swift.Result<[Chat], Error> {
        let allChats = self.allChats
        switch allChats {
        case .success(let chats):
            // Note that you can't do an SQL query to figure out if the chat has a known contact
            // because contacts are in a different store (the Contacts app).
            return .success(chats.filter { $0.recipient != nil })
        case .failure:
            return allChats
        }
    }

}
