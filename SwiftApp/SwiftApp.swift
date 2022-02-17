//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

enum DefaultsKey: String, CaseIterable {
    case counter
    case password
    case username
}

class SwiftApp {
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        self.style = AppStyle()
        self.style.onSet = { [ weak self] in
            guard let self = self else { return }
            self.setNeedsReload()
        }
        let vc = TableViewController(rootScreen.modelClosure(app: self))
        window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
        window.makeKeyAndVisible()
        
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsReload {
                self.topViewController?.loadModel()
                self.needsReload = false
            }
        }
    }
   
    private let window: UIWindow
    var style: AppStyle
    
    
    func getDefaultsItem(_ key: DefaultsKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func setDefaultsItem(_ key: DefaultsKey, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        setNeedsReload()
    }
    
    
    private var topViewController: TableViewController? {
        if let nc = window.rootViewController as? UINavigationController,
            let vc = nc.topViewController as? TableViewController {
            return vc
        } else if let vc = window.rootViewController as? TableViewController {
            return vc
        } else {
            return nil
        }
    }
    
    private var needsReload = false
    private func setNeedsReload() {
        needsReload = true
    }
    
    func push(_ screen: Screen) {
        guard let nc = window.rootViewController as? UINavigationController
        else {
            return
        }
        let vc = TableViewController(screen.modelClosure(app: self))
        nc.pushViewController(vc, animated: true)
    }
}
