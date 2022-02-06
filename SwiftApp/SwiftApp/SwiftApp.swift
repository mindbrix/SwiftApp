//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

class SwiftApp {
    enum Screen {
        case Main
        case Splash
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    var screen: Screen {
        get {
            _screen
        }
        set {
            _screen = newValue
            window.rootViewController = SwiftApp.makeViewController(for: _screen)
            window.makeKeyAndVisible()
        }
    }
   
    private let window: UIWindow
    private var _screen: Screen = .Main
    
    private static func makeViewController(for screen: Screen) -> UIViewController {
        let vc = ViewController()
        vc.getModel = {
            ViewModel.fullModel
        }
        return vc
    }
}
