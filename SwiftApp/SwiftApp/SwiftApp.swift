//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

class SwiftApp {
    enum StoreKey: String, CaseIterable {
        case counter
    }
    
    enum Screen: String, CaseIterable {
        case Main
        case Counter
        case Store
        
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
    
    private func getStoreItem(key: StoreKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    private func setStoreItem(key: StoreKey, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
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
                                    let splash = self.makeViewController(for: .Counter)
                                    vc.navigationController?.pushViewController(splash, animated: true)
                                }
                            ),
                            .button(
                                title: "Go to \(Screen.Store.rawValue)",
                                onTap: {
                                    let splash = self.makeViewController(for: .Store)
                                    vc.navigationController?.pushViewController(splash, animated: true)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Counter:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getStoreItem(key: .counter) as? Int ?? 0
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Count: \(count)"),
                            .button(
                                title: "Down",
                                onTap: {
                                    self.setStoreItem(key: .counter, value: max(0, count - 1))
                                }
                            ),
                            .button(
                                title: "Up",
                                onTap: {
                                    self.setStoreItem(key: .counter, value: count + 1)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Store:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: screen.rawValue),
                        cells: StoreKey.allCases.map({ key in Cell.standard(title: "\(key.rawValue): \(self.getStoreItem(key: key) ?? "nil")" ) })
                    )
                ])
            }
            break
        }
        return vc
    }
}
