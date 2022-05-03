//
//  MirroringPhoneBook.swift
//  iMessageBackupTests
//
//  Created by Patrick McGonigle on 5/2/22.
//

@testable import iMessageBackup

/// An contacts instance that  "mirrors" the request for testing.
struct MirroringPhoneBook: ReversePhoneBook {
    
    func confirmAccess() -> Bool { true }
    
    /// - Returns a person with an empty first name and `identifier` as their last name, for testing
    func findPerson(byIdentifier identifier: String) -> Person? {
        Person(firstName: "", lastName: identifier)
    }
    
}
