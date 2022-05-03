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
    private let reversePhoneBook: ReversePhoneBook

    /**
     Creates a chat database reader for the given database path.
     - Parameter dbPath: A path to the chat database.
     - Returns: A chat reader instance _or_ `nil` if the database can't be read.
     */
    init?(dbPath: String, reversePhoneBook: ReversePhoneBook) {
        // TODO patmcg make this throws (TEXTBAK-41)
        do {
            self.db = try Connection(dbPath, readonly: true)
            self.reversePhoneBook = reversePhoneBook
        } catch {
            return nil
        }
    }
    
    /// Creates a chat reader for the given database connection
    init(db: Connection, reversePhoneBook: ReversePhoneBook) {
        self.db = db
        self.reversePhoneBook = reversePhoneBook
    }
    
    /// Counts metrics from the chat database.
    var metrics: Swift.Result<ChatMetrics, Error> {
        // TODO patmcg make this throws (TEXTBAK-41)
        do {
            let numChats = try self.db?.scalar(self.chatTable.sqliteTable.select(self.chatTable.idColumn.count)) ?? -1
            let numMessages = try self.db?.scalar(self.messageTable.sqliteTable.select(self.messageTable.idColumn.count)) ?? -1
            return .success(ChatMetrics(numChats: numChats, numMessages: numMessages))
        } catch {
            return .failure(error)
        }
    }
    
    // TODO patmcg make this async (TEXTBAK-40)
    // TODO patmcg make this throws (TEXTBAK-41)
    /// Gets all the chats in the database
    var allChats: Swift.Result<[Chat], Error> {
        
        var result = [Chat]()
        
        if let database = self.db {
            do {
                let rowIterator = try database.prepareRowIterator(self.chatTable.sqliteTable)
                for chatRow in try Array(rowIterator) {
                    let chatIdentifier = chatRow[self.chatTable.chatIdentifierColumn]
                    // Note that this is effectively joining the chat db with a different store (the Contacts app).
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

    // TODO patmcg make this async (TEXTBAK-40)
    // TODO patmcg make this throws (TEXTBAK-41)
    /// Gets all the chats with known contact
    var allChatsWithKnownContacts: Swift.Result<[Chat], Error> {
        let allChats = self.allChats
        switch allChats {
        case .success(let chats):
            // Note that you can't do an SQL query to figure out if the chat has a known contact
            // because contacts are in a different store ^ (the Contacts app).
            return .success(chats.filter { $0.recipient != nil })
        case .failure:
            return allChats
        }
    }

}
