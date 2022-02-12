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
        case Fonts
        case Login
        
        var embedInNavController: Bool { self == .Main }
    }
    
    init(window: UIWindow) {
        self.window = window
        _ = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsRefresh {
                self.topViewController?.refresh()
            }
            self.needsRefresh = false
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
    
    private var needsRefresh = false
    private func refresh() {
        needsRefresh = true
    }
    
    private func makeViewController(for screen: Screen) -> TableViewController {
        let vc = TableViewController()
        switch screen {
        case .Main:
            vc.modelClosure = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .stack([
                            .text(self.style.name, alignment: .left),
                            .text("size: \(self.style.size)", alignment: .right)
                        ]),
                        cells: [
                            .stack([
                                .text("--fontSize", alignment: .center, onTap: { self.style = .init(name: self.style.name, size: max(4, self.style.size - 1)) }),
                                .text("fontSize++", alignment: .center, onTap: { self.style = .init(name: self.style.name, size: self.style.size + 1) })
                            ]),
                        ]),
                    Section(
                        header: .stack([.text("Menu")]),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ screen in
                            .stack([.text(screen.rawValue, scale: 100, alignment: .left, onTap: {
                                guard let nc = vc.navigationController else { return }
                                nc.pushViewController(self.makeViewController(for: screen), animated: true)
                            })])
                        })
                    ),
                    Section(
                        header: .stack([.text("Images")]),
                        cells: [
                            .stack([
                                .image(url: "grab0", onTap: { print("grab0") }),
                                .text(.longText, scale: 50)
                            ], isVertical: true),
                            .stack([
                                .image(url: "grab0", width: 64, onTap: { print("grab0") }),
                                .text(.longText, scale: 50)
                            ], isVertical: false),
                        ])
                ])
            }
        case .Counter:
            vc.modelClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([.text(String(count), scale: 200, alignment: .center)]),
                            .stack([
                                .text("Down", scale: 120, alignment: .center, onTap: {
                                    self.setDefaultsItem(.counter, value: max(0, count - 1))
                                }),
                                .text("Up", scale: 120, alignment: .center, onTap: {
                                    self.setDefaultsItem(.counter, value: count + 1)
                                })
                            ]),
                        ]
                    )
                ])
            }
        case .DefaultStore:
            vc.modelClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .stack([.text(screen.rawValue)]),
                        cells: DefaultsKey.allCases.map({ key in
                            .stack([
                                .text(key.rawValue),
                                .input(get: { String(describing: self.getDefaultsItem(key)) }, scale: 120)
                            ], isVertical: true)
                        })
                )])
            }
        case .DequeueTest:
            vc.modelClosure = {
                ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: .stack([.text(screen.rawValue)]),
                        cells: Array(1...100).map({ int in
                            .stack([
                                .text(String(int)),
                                .text(int % 2 == 0 ? "" : .longText)],
                                isVertical: true)
                        })
                    )
                ])
            }
        case .Fonts:
            vc.modelClosure = {
                return ViewModel(style: self.style, title: screen.rawValue, sections:
                    UIFont.familyNames.map({ familyName in
                        Section(
                            header: .stack([.text(familyName)]),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                .stack([.text(fontName, scale: 86, onTap: {
                                    self.style = .init(name: fontName, size: self.style.size)
                                })])
                            })
                        )
                    })
                )
            }
        case .Login:
            vc.modelClosure = {
                return ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text("User", scale: 86),
                                .input(
                                    get: { self.getDefaultsItem(.username) as? String ?? "" },
                                    set: { string in self.setDefaultsItem(.username, value: string) },
                                    scale: 120),
                                ], isVertical: true),
                            .stack([
                                .text("Password", scale: 86),
                                .input(
                                    get: { self.getDefaultsItem(.password) as? String ?? "" },
                                    set: { string in self.setDefaultsItem(.password, value: string) },
                                    scale: 120),
                            ], isVertical: true)
                        ]
                    )
                ])
            }
        }
        return vc
    }
}
