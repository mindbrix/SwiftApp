//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


class SwiftApp {
    let store = Store()
    let styleCache = StyleCache()
    
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        
        self.styleCache.onDidUpdate = { [weak self] in
            self?.reload()
        }
        self.store.onDidUpdate = { [weak self] in
            self?.reload()
        }
        
        let vc = makeScreenController(rootScreen)
        window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
        window.makeKeyAndVisible()
        
        let size = window.frame.size
        let scale = max(1, size.width / size.height)
        self.styleCache.size = round(scale * self.styleCache.size)
        
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsReload {
                self.topViewController?.loadModel()
                self.needsReload = false
            }
        }
    }
    
    func push(_ screen: Screen) {
        guard let nc = window.rootViewController as? UINavigationController
        else { return }
        
        let vc = makeScreenController(screen)
        nc.pushViewController(vc, animated: true)
    }
    
    func reload() {
        self.needsReload = true
    }
    
    
    private let window: UIWindow
    private var needsReload = false

    private func makeScreenController(_ screen: Screen) -> TableViewController {
        let vc = TableViewController()
        vc.loadClosure = screen.modelClosure(app: self)
        
        vc.onWillResize = { [weak self] vc, newSize in
            if let self = self, vc == self.topViewController {
                let size = vc.view.frame.size
                let scale = newSize.width / size.width
                self.styleCache.size = round(scale * self.styleCache.size)
            }
        }
        return vc
    }
    
    private var topViewController: TableViewController? {
        if let nc = window.rootViewController as? UINavigationController {
            return nc.topViewController as? TableViewController
        } else {
            return window.rootViewController as? TableViewController
        }
    }
}
