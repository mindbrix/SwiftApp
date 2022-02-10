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
        case password
        case username
    }
    
    enum Screen: String, CaseIterable {
        case Main
        case Counter
        case DefaultStore
        case DequeueTest
        case Login
        
        var embedInNavController: Bool { self == .Main }
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
    
    private var style: FontStyle = .defaultStyle {
        didSet {
            refresh()
        }
    }
    
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
                
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .header(caption: "Menu"),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ screen in
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
                        header: .header(caption: "fontSize: \(self.style.size)"),
                        cells: [
                            .button(
                                title: "fontSize++",
                                onTap: { self.style = .init(name: self.style.name, size: self.style.size + 1) }),
                            .button(
                                title: "fontSize = 10",
                                onTap: { self.style = .init(name: self.style.name, size: 10) })
                        ]),
                    Section(
                        header: .header(caption: "Images"),
                        cells: [
                            .image(
                                get: { UIImage(named: "grab0") },
                                caption: .longText,
                                isThumbnail: true),
                            .image(
                                get: { UIImage(named: "grab0") },
                                caption: .longText),
                            .button(
                                title: "Refresh",
                                onTap: { self.refresh() })
                        ])
                ])
            }
        case .Counter:
            vc.modelClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .header(caption: "Count"),
                        cells: [
                            .standard(
                                title: String(count)
                            ),
                            .button(
                                title: "Down",
                                onTap: { self.setDefaultsItem(.counter, value: max(0, count - 1)) }
                            ),
                            .button(
                                title: "Up",
                                onTap: { self.setDefaultsItem(.counter, value: count + 1) }
                            )
                        ]
                    )
                ])
            }
        case .DefaultStore:
            vc.modelClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .header(caption: screen.rawValue),
                        cells: DefaultsKey.allCases.map({ key in
                            .textInput(
                                key: key.rawValue,
                                get: { String(describing: self.getDefaultsItem(key)) },
                                set: nil)
                        })
                )])
            }
        case .DequeueTest:
            vc.modelClosure = {
                ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .header(caption: screen.rawValue),
                        cells: Array(1...100).map({ int in
                            .standard(
                                title: String(int),
                                caption: int % 2 == 0 ? nil : .longText)
                        })
                    )
                ])
            }
        case .Login:
            vc.modelClosure = {
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .textInput(
                                key: "User",
                                get: { self.getDefaultsItem(.username) as? String ?? "" },
                                set: { string in self.setDefaultsItem(.username, value: string) }),
                            .textInput(
                                key: "Password",
                                get: { self.getDefaultsItem(.password) as? String ?? "" },
                                set: { string in self.setDefaultsItem(.password, value: string) }),
                            .button(
                                title: "Login",
                                onTap: {
                                }
                            ),
                        ]
                    )
                ])
            }
        }
        return vc
    }
}
