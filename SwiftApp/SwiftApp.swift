//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


class SwiftApp {
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        self.styleCache.didUpdate = { [weak self] in
            self?.needsReload = true
        }
        self.store.didUpdate = { [weak self] in
            self?.needsReload = true
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
    
    var store = Store()
    var styleCache = StyleCache()
    private let window: UIWindow
    private var needsReload = false

    func push(_ screen: Screen) {
        guard let nc = window.rootViewController as? UINavigationController
        else {
            return
        }
        let vc = TableViewController(screen.modelClosure(app: self))
        nc.pushViewController(vc, animated: true)
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
}
