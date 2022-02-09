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
        case Login
        case TextInputTest
        
        var embedInNavController: Bool {
            self == .Main
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        for int in 1 ... 100 {
            strings[int] = "\(int)"
        }
    }
    
    var rootScreen: Screen = .Main {
        didSet {
            let vc = makeViewController(for: rootScreen)
            window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
            window.makeKeyAndVisible()
        }
    }
   
    private let window: UIWindow
    private var strings: [Int: String] = [:]
    
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
            vc.modelClosure = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: "Menu"),
                        cells: Screen.allCases.filter({ $0 != .Main }).map({ screen in
                            .standard(
                                title: screen.rawValue,
                                onTap: {
                                    guard let nc = vc.navigationController else { return }
                                    nc.pushViewController(self.makeViewController(for: screen), animated: true)
                                }
                            )
                        })
                    ),
                    Section(
                        header: .header(title: "Images"),
                        cells: [
                            .thumbnail(
                                get: { UIImage(named: "avatar") },
                                caption: .longText,
                                onTap: nil),
                            .button(
                                title: "Refresh",
                                onTap: {
                                    self.refresh()
                                })
                        ])
                ])
            }
        case .Counter:
            vc.modelClosure = { [weak self] in
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
            vc.modelClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                return ViewModel(title: screen.rawValue, sections:
                    DefaultsKey.allCases.map({ key in
                        Section(
                            header: .header(title: key.rawValue),
                            cells: [
                                .standard(title: String(describing: self.getDefaultsItem(key)))
                            ]
                        )
                    }))
            }
        case .DequeueTest:
            vc.modelClosure = {
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
        case .Login:
            vc.modelClosure = {
                ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: screen.rawValue),
                        cells: [
                            .textInput(
                                title: "User",
                                get: {"nigel@mindbrix.co.uk" },
                                set: { string in }),
                            .textInput(
                                title: "User",
                                get: {"password" },
                                set: { string in }),
                            .button(
                                title: "Login",
                                onTap: {
                                }
                            ),
                        ]
                    )
                ])
            }
        case .TextInputTest:
            vc.modelClosure = {
                ViewModel(title: screen.rawValue, sections: [
                    Section(
                        header: .header(title: screen.rawValue),
                        cells: self.strings.keys.sorted().map({ key in
                            Cell.textInput(
                                title: "\(key)",
                                get: { self.strings[key] ?? "" },
                                set: { string in self.strings[key] = string })
                        })
                    )
                ])
            }
        }
        return vc
    }
}
