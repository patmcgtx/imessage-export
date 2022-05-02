//
//  Contacts.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Contacts

/// TODO patmcg
struct Contacts {
    
    /// TODO patmcg doc
    func requestContactsAccess() -> Bool {

        // TODO patmcg come back tp this and give it a nice async/await API.
        //             Figure out how to reset ,notDetermined and retest.

        // I have access from being prompted before, so unblocked for now
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
    
    /// TODO patmcg doc
    func person(identifiedAs identifier: String) -> Person? {
        var retval: Person? = nil
        do {
            let store = CNContactStore()
//            let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
//            let phone = CNPhoneNumber(stringValue: identifier)
//            let predicate = CNContact.predicateForContacts(matching: phone)
            let predicate = CNContact.predicateForContacts(matchingEmailAddress: identifier)
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            let contacts: [CNContact] = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            if let contact = contacts.first {
                retval = Person(firstName: contact.givenName, lastName: contact.familyName)
            }
        } catch {
            // TODO patmcg Improve error handling
            print("Failed to fetch contact, error: \(error)")
        }
        return retval
    }
    
}

