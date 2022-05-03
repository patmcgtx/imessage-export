//
//  ReversePhoneBook.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

/// A service that can look up people by their contact info.
protocol ReversePhoneBook {

    /**
     Verifies or obtains permission to read contacts.
     - Returns: `true` if this app has or was able to obtain permission to read contacts, `false` otherwise.
     */
    func confirmAccess() -> Bool
    // TODO patmcg make this async (TEXTBAK-40)

    /**
     Looks up a person by a phone or email identifier.
     - Parameter identifiedAs: A phone number or email address to identify a person.
     - Returns: A person with the given identifier, or `nil` if none can be found.
     */
    func findPerson(byIdentifier identifier: String) -> Person?
    // TODO patmcg make this throws (TEXTBAK-41)
}
    


