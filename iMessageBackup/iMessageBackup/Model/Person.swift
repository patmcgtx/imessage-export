//
//  Person.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Foundation

/// Represents a person taking part in a chat.
struct Person {
    
    let firstName: String
    let lastName: String
    
    var debugDescription: String {
        let formatted = [firstName, lastName].filter{!$0.isEmpty}.joined(separator: " ")
        return formatted.isEmpty ? "<nameless>" : "[\(formatted)]"
    }
}
