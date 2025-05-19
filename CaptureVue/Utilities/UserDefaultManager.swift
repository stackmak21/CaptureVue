//
//  UserDefaultManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/5/25.
//

import Foundation


class UserDefaultManager{
    
    static let shared: UserDefaultManager = UserDefaultManager()
    
    private init(){}
    
    func saveData<T: Codable>(data: T, key: UserDefaultKeys){
        do{
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
        }
        catch(let error){
            log.error(error.localizedDescription)
        }
    }
    
    func fetchData<T: Codable>(key: UserDefaultKeys) -> T? {
        do{
            guard let fetchedData = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
            let decodedData = try JSONDecoder().decode(T.self, from: fetchedData)
            return decodedData
        }
        catch(let error){
            log.error(error.localizedDescription)
            return nil
        }
    }
    
    func removeData(key: UserDefaultKeys){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    
    enum UserDefaultKeys: String{
        case createEventDraft
    }
    
}
