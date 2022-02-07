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
        
        var embedInNavController: Bool {
            self == .Main
        }
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    var rootScreen: Screen = .Main {
        didSet {
            let vc = makeViewController(for: rootScreen)
            window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
            window.makeKeyAndVisible()
        }
    }
   
    private let window: UIWindow
    
    private var topViewController: ViewController? {
        if let nc = window.rootViewController as? UINavigationController, let vc = nc.topViewController as? ViewController {
            return vc
        } else if let vc = window.rootViewController as? ViewController {
            return vc
        } else {
            return nil
        }
    }
    
    private func refresh() {
        topViewController?.refresh()
    }
    
    private func makeViewController(for screen: Screen) -> UIViewController {
        let vc = ViewController()
        switch screen {
        case .Main:
            vc.getModel = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(title: String(describing: screen), sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Standard cell"),
                            .button(
                                title: "Go to Splash",
                                onTap: {
                                    print("onTap")
                                    let splash = self.makeViewController(for: .Splash)
                                    vc.navigationController?.pushViewController(splash, animated: true)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Splash:
            vc.getModel = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(title: String(describing: screen), sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Standard cell"),
                            .button(
                                title: "Go to Main",
                                onTap: {
                                    print("onTap")
//                                    self.rootScreen = .Main
                                    self.refresh()
                                }
                            )
                        ]
                    )
                ])
            }
        }
        return vc
    }
}
