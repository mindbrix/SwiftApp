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
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsReload {
                self.topViewController?.loadModel()
            }
            self.needsReload = false
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
            setNeedsReload()
        }
    }
    
    private func getDefaultsItem(_ key: DefaultsKey) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    private func setDefaultsItem(_ key: DefaultsKey, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        setNeedsReload()
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
    
    private var needsReload = false
    private func setNeedsReload() {
        needsReload = true
    }
    
    private func makeViewController(for screen: Screen) -> TableViewController {
        let vc = TableViewController()
        let title = screen.rawValue
        let largeScale: CGFloat = 120
        let hugeScale: CGFloat = 200
        let tinyStyle: Atom.TextStyle = .init(scale: 50)
        let smallStyle: Atom.TextStyle = .init(scale: 86)
        let largeStyle: Atom.TextStyle = .init(scale: largeScale)
        let counterStyle: Atom.TextStyle = .init(scale: largeScale, alignment: .center)
        
        switch screen {
        case .Main:
            vc.loadClosure = { [weak self, weak vc] in
                guard let self = self, let vc = vc else { return ViewModel.emptyModel }
                
                return ViewModel(style: self.style, title: title, sections: [
                    Section(
                        header: .stack([
                            .text(self.style.name, style: .init(alignment: .center), onTap: {
                                guard let nc = vc.navigationController else { return }
                                nc.pushViewController(self.makeViewController(for: .Fonts), animated: true)
                            }),
                        ]),
                        cells: [
                            .stack([
                                .text("--", style: counterStyle, onTap: {
                                    self.style = .init(name: self.style.name, size: max(4, self.style.size - 1))
                                }),
                                .text("\(self.style.size)", style: counterStyle),
                                .text("++", style: counterStyle, onTap: {
                                    self.style = .init(name: self.style.name, size: self.style.size + 1)
                                })
                            ]),
                        ]),
                    Section(
                        header: .stack([.text("Menu")]),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ screen in
                            .stack([.text(screen.rawValue, onTap: {
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
                                .text(.longText, style: tinyStyle)
                            ], isVertical: true),
                            .stack([
                                .image(url: "grab0", width: 64, onTap: { print("grab0") }),
                                .text(.longText, style: tinyStyle),
                                .image(url: "grab0", width: 64, onTap: { print("grab0") }),
                            ], isVertical: false),
                        ])
                ])
            }
        case .Counter:
            vc.loadClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                let count = self.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(style: self.style, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([.text(String(count), style: .init(scale: hugeScale, alignment: .center))]),
                            .stack([
                                .text("Down", style: counterStyle, onTap: {
                                    self.setDefaultsItem(.counter, value: max(0, count - 1))
                                }),
                                .text("Up", style: counterStyle, onTap: {
                                    self.setDefaultsItem(.counter, value: count + 1)
                                })
                            ]),
                        ]
                    )
                ])
            }
        case .DefaultStore:
            vc.loadClosure = { [weak self] in
                guard let self = self else { return ViewModel.emptyModel }
                return ViewModel(style: self.style, title: title, sections: [
                    Section(
                        header: .stack([.text(title)]),
                        cells: DefaultsKey.allCases.map({ key in
                            .stack([
                                .text(key.rawValue),
                                .input(
                                    value: String(describing: self.getDefaultsItem(key)),
                                    scale: largeScale)
                            ], isVertical: true)
                        })
                )])
            }
        case .DequeueTest:
            vc.loadClosure = {
                ViewModel(style: self.style, title: title, sections: [
                    Section(
                        header: .stack([.text(title)]),
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
            vc.loadClosure = {
                return ViewModel(style: self.style, title: title, sections:
                    UIFont.familyNames.map({ familyName in
                        Section(
                            header: .stack([.text(familyName)]),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                .stack([.text(fontName, style: smallStyle, onTap: {
                                    self.style = .init(name: fontName, size: self.style.size)
                                })])
                            })
                        )
                    })
                )
            }
        case .Login:
            vc.loadClosure = {
                return ViewModel(style: self.style, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text("User", style: smallStyle),
                                .input(
                                    value: self.getDefaultsItem(.username) as? String ?? "",
                                    onSet: { string in
                                        self.setDefaultsItem(.username, value: string)
                                    },
                                    scale: largeScale),
                                ], isVertical: true),
                            .stack([
                                .text("Password", style: smallStyle),
                                .input(
                                    value: self.getDefaultsItem(.password) as? String ?? "",
                                    onSet: { string in
                                        self.setDefaultsItem(.password, value: string)
                                    },
                                    scale: largeScale),
                            ], isVertical: true)
                        ]
                    )
                ])
            }
        }
        return vc
    }
}
