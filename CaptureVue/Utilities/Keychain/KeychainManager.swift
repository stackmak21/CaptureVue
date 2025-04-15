//
//  KeychainManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/1/25.
//

import Foundation
import SwiftUI
import KeychainSwift


final class KeychainManager {
    
    private let keychain: KeychainSwift
    
    init() {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        self.keychain = keychain
    }
    
    func save(_ value: String, key: KeychainKeys){
        keychain.set(value, forKey: key.rawValue)
    }
    
    func get(key: KeychainKeys) -> String? {
        keychain.get(key.rawValue)
    }
    
    func saveData<T: Codable>(_ object: T, key: KeychainKeys){
        do{
            let data = try JSONEncoder().encode(object)
            keychain.set(data, forKey: key.rawValue)
        }
        catch(let error){
            print("Failed to encode object to data with error: \(error)")
        }
    }
    
    func getData<T: Codable>(key: KeychainKeys) -> T? {
        do{
            guard let fetchedData = keychain.getData(key.rawValue) else { return nil }
            return try JSONDecoder().decode(T.self, from: fetchedData)
        }
        catch(let error){
            print("Failed to decode object from keychain to data with error: \(error)")
            return nil
        }
    }
    
    
    enum KeychainKeys: String {
        case token, refreshToken, deviceId, credentials, customer
    }
    
}

//@propertyWrapper
//struct KeychainStorage<T: Codable>: DynamicProperty{
//    
//    @State private var newValue: T
//    let key: KeychainKeys
//    let keychain: KeychainManager
//    
//    var wrappedValue: T {
//        get{
//            newValue
//        }
//        nonmutating set{
//            save(newValue)
//        }
//    }
//    
//    var projectedValue: Binding<T> {
//        Binding(
//            get: { wrappedValue },
//            set: { newValue in
//                wrappedValue = newValue
//            }
//        )
//    }
//    
//    init(wrappedValue: T, _ key: KeychainKeys){
//        self.key = key
//        self.keychain = KeychainManager()
//        
//        if T.self == String.self, let storedValue = keychain.get(key: key.rawValue) as? T{
//            self.newValue = storedValue
//        }
//        else if let storedValue: T = keychain.getData(key: key.rawValue) {
//            self.newValue = storedValue
//        }
//        else{
//            self.newValue = wrappedValue
//        }
//    }
//    
//    func save(_ newValue: T){
//        if let value = newValue as? String{
//            keychain.save(value, key: key.rawValue)
//        }
//        else{
//            keychain.saveData(newValue, key: key.rawValue)
//        }
//        self.newValue = newValue
//    }
//}
//
//enum KeychainKeys: String{
//    case token = "server_token"
//    case credentials = "user_credentials"
//}



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
