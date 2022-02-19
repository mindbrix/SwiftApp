//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

extension UIInterfaceOrientation {
    var scale: CGFloat {
        switch self {
        case .portrait, .portraitUpsideDown:
            return 1
        default:
            return 1.6
        }
    }
}

class SwiftApp {
    let store = Store()
    let styleCache = StyleCache()
    
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        
        self.styleCache.didUpdate = { [weak self] in
            self?.reload()
        }
        self.store.didUpdate = { [weak self] in
            self?.reload()
        }
        
        let vc = makeScreenController(rootScreen)
        self.styleCache.size = round(self.styleCache.size * vc.interfaceOrientation.scale)
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
        let vc = TableViewController(screen.modelClosure(app: self))
        vc.onRotate = { [weak self] vc, previous in
            guard let self = self
            else { return }
            
            let scale = vc.interfaceOrientation.scale / previous.scale
            self.styleCache.size = round(scale * self.styleCache.size)
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
