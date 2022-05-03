//
//  InMemoryContacts.swift
//  iMessageBackupTests
//
//  Created by Patrick McGonigle on 5/2/22.
//

@testable import iMessageBackup

/// A read/write in-memory contacts instance for testing
struct InMemoryContacts: ReversePhoneBook {
    
    func confirmAccess() -> Bool { true }
    
    func findPerson(byIdentifier identifier: String) -> Person? {
        Person(firstName: "", lastName: identifier)
    }
    
}
