//
//  KeychainManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/1/25.
//

import Foundation
import SwiftUI
import KeychainSwift


struct KeychainManager {
    
    private let keychain: KeychainSwift
    
    init() {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        self.keychain = keychain
    }
    
    func save(_ value: String, key: String){
        keychain.set(value, forKey: key)
    }
    
    func get(key: String) -> String? {
        keychain.get(key)
    }
}

@propertyWrapper
struct KeychainStorage: DynamicProperty{
    
    @State private var newValue: String
    let key: String
    let keychain: KeychainManager
    
    var wrappedValue: String {
        get{
            newValue
        }
        nonmutating set{
            save(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<String> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                wrappedValue = newValue
            }
        )
    }
    
    init(wrappedValue: String, _ key: String){
        self.key = key
        let keychain = KeychainManager()
        self.keychain = keychain
        newValue = keychain.get(key: key) ?? ""
    }
    
    func save(newValue: String){
        keychain.save(newValue, key: key)
        self.newValue = newValue
    }
}



//import Security

//final class KeychainManager {
//    static let instance = KeychainManager()
//    private init() {}
//
//    enum KeychainError: Error {
//        case duplicateEntry
//        case unknown(OSStatus)
//    }
//
//    func saveToken(_ token: String, forKey key: String) throws {
//        if let data = token.data(using: .utf8) {
//
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrAccount as String: key,
//                kSecValueData as String: data,
//                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
//            ]
//
//            let status = SecItemAdd(query as CFDictionary, nil)
//
//            guard status != errSecDuplicateItem else {
//                throw KeychainError.duplicateEntry
//            }
//            guard status == errSecSuccess else {
//                throw KeychainError.unknown(status)
//            }
//        }
//    }
//
//    func getToken(forKey key: String) -> String? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String: true,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//        var dataTypeRef: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//        if status == errSecSuccess, let data = dataTypeRef as? Data {
//            return String(data: data, encoding: .utf8)
//        }
//        return nil
//    }
//}
