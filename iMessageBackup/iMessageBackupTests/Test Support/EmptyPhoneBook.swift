//
//  EmptyPhoneBook.swift
//  iMessageBackupTests
//
//  Created by Patrick McGonigle on 5/2/22.
//

@testable import iMessageBackup

/// An "empty" contacts instance for testing.
struct EmptyPhoneBook: ReversePhoneBook {
    
    func confirmAccess() -> Bool { true }
    
    func findPerson(byIdentifier identifier: String) -> Person? { nil }
    
}
