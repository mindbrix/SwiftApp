//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

class SwiftApp {
    enum DefaultsKey: String, CaseIterable {
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
    
    private func getDefaultsItem(key: DefaultsKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    private func setDefaultsItem(key: DefaultsKey, value: Any) {
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
                                    guard let nc = vc.navigationController else { return }
                                    nc.pushViewController(self.makeViewController(for: .Counter), animated: true)
                                }
                            ),
                            .button(
                                title: "Go to \(Screen.Store.rawValue)",
                                onTap: {
                                    guard let nc = vc.navigationController else { return }
                                    nc.pushViewController(self.makeViewController(for: .Store), animated: true)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Counter:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getDefaultsItem(key: .counter) as? Int ?? 0
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: "Header"),
                        cells: [
                            .standard(title: "Count: \(count)"),
                            .button(
                                title: "Down",
                                onTap: {
                                    self.setDefaultsItem(key: .counter, value: max(0, count - 1))
                                }
                            ),
                            .button(
                                title: "Up",
                                onTap: {
                                    self.setDefaultsItem(key: .counter, value: count + 1)
                                }
                            )
                        ]
                    )
                ])
            }
        case .Store:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                
                let cells = DefaultsKey.allCases.map({ key in
                    Cell.standard(
                        title: key.rawValue,
                        body: String(self.getDefaultsItem(key: key) as? Int ?? 0))
                })
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .standard(title: screen.rawValue),
                        cells: cells
                    )
                ])
            }
            break
        }
        return vc
    }
}
