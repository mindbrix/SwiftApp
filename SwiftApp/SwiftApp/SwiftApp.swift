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
                            .standard(
                                title: "Go to Splash",
                                onTap: {
                                    print("onTap")
                                    vc.navigationController?.pushViewController(self.makeViewController(for: .Splash), animated: true)
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
                            .standard(
                                title: "Go to Main",
                                onTap: {
                                    print("onTap")
                                    self.rootScreen = .Main
//                                    vc.refresh()
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
