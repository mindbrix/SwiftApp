//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

class SwiftApp {
    enum ItemKey: String {
        case counter
    }
    
    enum Screen: String, CaseIterable {
        case Main
        case Counter
        
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
    
    private var store: [ItemKey: Any] = [.counter: 0]
    
    private func getStoreItem(item: ItemKey) -> Any? {
        store[item]
    }
    
    private func setStoreItem(item: ItemKey, value: Any) {
        store[item] = value
        refresh()
    }
    
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
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Standard cell"),
                            .button(
                                title: "Go to \(Screen.Counter.rawValue)",
                                onTap: {
                                    print("onTap")
                                    let splash = self.makeViewController(for: .Counter)
                                    vc.navigationController?.pushViewController(splash, animated: true)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Counter:
            vc.getModel = { [weak self, weak vc] in
                guard let self = self, let vc = vc, let count = self.getStoreItem(item: .counter) as? Int else { return ViewModel.emptyModel }
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Count: \(count)"),
                            .button(
                                title: "Down",
                                onTap: {
                                    self.setStoreItem(item: .counter, value: max(0, count - 1))
                                }
                            ),
                            .button(
                                title: "Up",
                                onTap: {
                                    self.setStoreItem(item: .counter, value: count + 1)
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
