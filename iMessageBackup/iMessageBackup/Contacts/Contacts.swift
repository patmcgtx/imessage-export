//
//  Contacts.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Contacts

struct Contacts {
    
    func fetchContact() {
        
        // TODO patmcg can I get rid of this authorizationStatus check?
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorized:
            print("authorized")
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: CNEntityType.contacts) { accessAllowed, error in
                if accessAllowed {
                    do {
                        let predicate = CNContact.predicateForContacts(matchingName: "Appleseed")
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
                        let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                        print("Fetched contacts: \(contacts)")
                    } catch {
                        print("Failed to fetch contact, error: \(error)")
                        // Failed to fetch contact, error: Error Domain=CNErrorDomain Code=100 "Access Denied" UserInfo={NSLocalizedDescription=Access Denied, NSLocalizedFailureReason=This application has not been granted permission to access Contacts.}
                    }
                } else {
                    print("Contacts access not allowed: \(String(describing: error?.localizedDescription))")
                }
            }
        @unknown default:
            print("unknown")
        }
        
    }
    
}
