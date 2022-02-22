//
//  Store.swift
//  SwiftApp
//
//  Created by Nigel Barber on 17/02/2022.
//

import Foundation

class Store {
    enum Key: String, CaseIterable {
        case counter
        case password
        case username
        
        var defaultValue: Any {
            switch self {
            case .counter:
                return 0
            case .password:
                return ""
            case .username:
                return ""
            }
        }
    }
    
    var onDidUpdate: (() -> Void)?
    
    func get(_ key: Key) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func getInt(_ key: Key) -> Int {
        return ((get(key) ?? key.defaultValue) as? Int) ?? 0
    }
    
    func getString(_ key: Key) -> String {
        return ((get(key) ?? key.defaultValue) as? String) ?? ""
    }
    
    func set(_ key: Key, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        onDidUpdate?()
    }
}
