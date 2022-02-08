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
        case DefaultStore
        case DequeueTest
        
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
    
    private func getDefaultsItem(_ key: DefaultsKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    private func setDefaultsItem(_ key: DefaultsKey, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        refresh()
    }
    
    private var topViewController: TableViewController? {
        if let nc = window.rootViewController as? UINavigationController, let vc = nc.topViewController as? TableViewController {
            return vc
        } else if let vc = window.rootViewController as? TableViewController {
            return vc
        } else {
            return nil
        }
    }
    
    private func refresh() {
        topViewController?.refresh()
    }
    
    private func makeViewController(for screen: Screen) -> UIViewController {
        let vc = TableViewController()
        switch screen {
        case .Main:
            vc.getModel = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: "Menu"),
                        cells: Screen.allCases.filter({ $0 != .Main }).map({ screen in
                            .button(
                                title: screen.rawValue,
                                onTap: {
                                    guard let nc = vc.navigationController else { return }
                                    nc.pushViewController(self.makeViewController(for: screen), animated: true)
                                }
                            )
                        })
                    )
                ])
            }
        case .Counter:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: "Count"),
                        cells: [
                            .standard(title: String(count)),
                            .button(
                                title: "Down",
                                onTap: {
                                    self.setDefaultsItem(.counter, value: max(0, count - 1))
                                }
                            ),
                            .button(
                                title: "Up",
                                onTap: {
                                    self.setDefaultsItem(.counter, value: count + 1)
                                }
                            )
                        ]
                    )
                ])
            }
        case .DefaultStore:
            vc.getModel = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: screen.rawValue),
                        cells: DefaultsKey.allCases.map({ key in
                            Cell.standard(
                                title: key.rawValue,
                                body: String(describing: self.getDefaultsItem(key)))
                        })
                    )
                ])
            }
        case .DequeueTest:
            vc.getModel = {
                ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: screen.rawValue),
                        cells: Array(1...100).map({ int in
                            Cell.standard(
                                title: String(int),
                                body: int % 2 == 0 ? nil : .longText)
                        })
                    )
                ])
            }
        }
        return vc
    }
}
