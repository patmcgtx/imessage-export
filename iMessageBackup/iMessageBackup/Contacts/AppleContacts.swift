//
//  AppleContacts.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Contacts

/// An Apple Contacts implementation of a `ReversePhoneBook`.
struct AppleContacts: ReversePhoneBook {

    private let store = CNContactStore()

    // MARK: - ReversePhoneBook
    
    func findPerson(byIdentifier identifier: String) -> Person? {
        
        var retval: Person? = nil
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        
        do {
            // First try by phone number
            let phone = CNPhoneNumber(stringValue: identifier)
            let predicate = CNContact.predicateForContacts(matching: phone)
            let contacts: [CNContact] = try self.store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            
            if let contact = contacts.first {
                retval = Person(firstName: contact.givenName, lastName: contact.familyName)
            } else {
                // If not found by phone number, try by email address
                let predicate = CNContact.predicateForContacts(matchingEmailAddress: identifier)
                let contacts: [CNContact] = try self.store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                if let contact = contacts.first {
                    retval = Person(firstName: contact.givenName, lastName: contact.familyName)
                }
            }
        } catch {
            // TODO patmcg Improve error handling; consider throwing to distinguish an error vs. just not finding a person
            print("Failed to fetch contact, error: \(error)")
        }
        
        return retval
    }

    func confirmAccess() -> Bool {

        // TODO patmcg come back to this and give it a nice async/await API (TEXTBAK-35).
        //             Figure out how to reset to .notDetermined and retest live.
        //             (I have access from being prompted before, so unblocked for now.)
        return true
                
        /*
        var retval = false
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            print("authorized")
        case .restricted, .denied, .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: CNEntityType.contacts) { accessAllowed, error in
                retval = accessAllowed
            }
        @unknown default:
            // TODO patmcg Improve error handling
            print("unknown")
        }
        return retval
         */
    }
        
}
