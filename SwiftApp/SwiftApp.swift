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
        case Atoms
        case Counter
        case DefaultStore
        case DequeueTest
        case Fonts
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
                        header: .cell([.text("Menu")]),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ screen in
                            .cell([.text(screen.rawValue, scale: 100, alignment: .left, onTap: {
                                guard let nc = vc.navigationController else { return }
                                nc.pushViewController(self.makeViewController(for: screen), animated: true)
                            })])
                        })
                    ),
                    Section(
                        header: .cell([.text("fontSize: \(self.style.size)")]),
                        cells: [
                            .cell([.text("fontSize++", onTap: { self.style = .init(name: self.style.name, size: self.style.size + 1) })]),
                            .cell([.text("fontSize = 10", onTap: { self.style = .init(name: self.style.name, size: 10) })]),
                        ]),
                    Section(
                        header: .cell([.text("Images")]),
                        cells: [
                            .image(
                                get: { UIImage(named: "grab0") },
                                caption: .longText,
                                isThumbnail: true),
                            .image(
                                get: { UIImage(named: "grab0") },
                                caption: .longText),
                        ])
                ])
            }
        case .Atoms:
            vc.modelClosure = {
                ViewModel(style: self.style, title: screen.rawValue, sections: [
                    Section(header: nil, cells:[
                        .cell([
                            .text("Text 1", scale: 86, alignment: .left, onTap: {
                                print("Text 1")
                            }),
                            .text("Text 2", scale: 120, alignment: .right, onTap: {
                                print("Text 2")
                            })
                        ]),
                        .cell([
                            .image(get: { UIImage(named: "grab0") }, onTap: {
                                print("grab0")
                            }),
                            .input(get: { "Input" }, set: { string in })
                        ], isVertical: true)
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
                            .cell([.text(String(count), scale: 200, alignment: .center)]),
                            .cell([
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
                        header: .cell([.text(screen.rawValue)]),
                        cells: DefaultsKey.allCases.map({ key in
                            .cell([
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
                        header: .cell([.text(screen.rawValue)]),
                        cells: Array(1...100).map({ int in
                            .cell([
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
                            header: .cell([.text(familyName)]),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                .cell([.text(fontName, onTap: {
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
                            .cell([
                                .text("User"),
                                .input(
                                    get: { self.getDefaultsItem(.username) as? String ?? "" },
                                    set: { string in self.setDefaultsItem(.username, value: string) },
                                    scale: 120),
                                ], isVertical: true),
                            .cell([
                                .text("Password"),
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
