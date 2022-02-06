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
    
    var screen: Screen = .Main {
        didSet {
            let vc = makeViewController(for: screen)
            window.rootViewController = screen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
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
                
                return ViewModel(sections: [
                    Section(
                        header: .standard(title: String(describing: screen)),
                        cells: [
                            .standard(
                                title: "Go to Splash",
                                onTap: {
                                    print("onTap")
                                    self.screen = .Splash
//                                    vc.refresh()
                                }
                            )
                        ]
                    )
                ])
            }
        case .Splash:
            vc.getModel = { [weak vc] in
                guard let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(sections: [
                    Section(
                        header: .standard(title: String(describing: screen)),
                        cells: [
                            .standard(
                                title: "Go to Main",
                                onTap: {
                                    print("onTap")
                                    self.screen = .Main
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
