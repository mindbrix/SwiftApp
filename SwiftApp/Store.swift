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
    }
    
    var didUpdate: (() -> Void)?
    
    func get(_ key: Key) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func set(_ key: Key, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        didUpdate?()
    }
}
