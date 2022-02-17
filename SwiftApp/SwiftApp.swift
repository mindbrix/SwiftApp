//
//  SwiftApp.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

class SwiftApp {
    struct FontStyle: Equatable {
        let name: String
        let size: CGFloat
        
        static let defaultStyle = Self(name: "HelveticaNeue", size: 18)
    }
    
    enum DefaultsKey: String, CaseIterable {
        case counter
        case password
        case username
    }
    
    init(_ window: UIWindow, rootScreen: Screen) {
        self.window = window
        updateStyles()
        let vc = makeViewController(for: rootScreen)
        window.rootViewController = rootScreen.embedInNavController ? UINavigationController(rootViewController: vc) : vc
        window.makeKeyAndVisible()
        
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.needsReload {
                self.topViewController?.loadModel()
                self.needsReload = false
            }
        }
    }
   
    private let window: UIWindow
    
    private var style: FontStyle = .defaultStyle {
        didSet {
            guard style != oldValue else { return }
            updateStyles()
            setNeedsReload()
        }
    }
    var smallStyle = TextStyle()
    var defaultStyle = TextStyle()
    var largeStyle = TextStyle()
    var hugeStyle = TextStyle()
    var counterStyle = TextStyle()
    var modelStyle = Style()
    var minusImage = UIImage()
    var plusImage = UIImage()
    
    private func updateStyles() {
        let name = self.style.name, size = self.style.size
        let smallFont = UIFont(name: name, size: size * 0.86)
        let defaultFont = UIFont(name: name, size: size)
        let largeFont = UIFont(name: name, size: size * 1.2)
        let hugeFont = UIFont(name: name, size: size * 1.6)
        
        smallStyle = .init(color: .gray, font: smallFont)
        defaultStyle = .init(font: defaultFont)
        largeStyle = .init(font: largeFont)
        hugeStyle = .init(font: hugeFont, alignment: .center)
        counterStyle = .init(font: largeFont, alignment: .center)
        modelStyle = .init(text: defaultStyle)
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
        minusImage = UIImage(
            systemName: "minus.circle",
            withConfiguration: config
        ) ?? UIImage()
        plusImage = UIImage(
            systemName: "plus.circle",
            withConfiguration: config
        ) ?? UIImage()
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
        if let nc = window.rootViewController as? UINavigationController,
            let vc = nc.topViewController as? TableViewController {
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
    
    func push(_ screen: Screen) {
        guard let nc = window.rootViewController as? UINavigationController
        else {
            return
        }
        let vc = makeViewController(for: screen)
        nc.pushViewController(vc, animated: true)
    }
    
    private func makeViewController(for screen: Screen) -> TableViewController {
        let vc = TableViewController()
        let title = screen.rawValue
        let grab0 = UIImage(named: "grab0") ?? UIImage()
        let vertical: CellStyle = .init(isVertical: true)
        
        switch screen {
        case .Main:
            vc.loadClosure = { [weak self] in
                guard let app = self else {
                    return ViewModel.emptyModel
                }
                let name = app.style.name, size = app.style.size
                return ViewModel(style: app.modelStyle, title: title, sections: [
                    Section(
                        header: .stack([
                            .text(app.style.name, style: .init(alignment: .center), onTap: {
                                app.push(.Fonts)
                            }),
                        ]),
                        cells: [
                            .stack([
                                .image(app.minusImage, width: size, onTap: {
                                    app.style = .init(name: name, size: max(4, size - 1))
                                }),
                                .text("\(size)", style: app.counterStyle),
                                .image(app.plusImage, width: size, onTap: {
                                    app.style = .init(name: name, size: size + 1)
                                })
                            ]),
                        ]),
                    Section(
                        header: .stack([.text("Menu")]),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ screen in
                            .stack([.text(screen.rawValue, onTap: {
                                app.push(screen)
                            })])
                        })
                    ),
                    Section(
                        header: .stack([.text("Images")]),
                        cells: [
                            .stack([
                                .image(grab0, onTap: { print("grab0") }),
                                .text(.longText, style: app.smallStyle)
                            ], style: vertical),
                            .stack([
                                .image(grab0, width: 64, onTap: { print("grab0") }),
                                .text(.longText, style: app.smallStyle),
                            ]),
                        ])
                ])
            }
        case .Counter:
            vc.loadClosure = { [weak self] in
                guard let app = self else { return ViewModel.emptyModel }
                let count = app.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(style: app.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text(String(count),
                                    style: app.hugeStyle)]),
                            .stack([
                                .text("Down",
                                    style: app.counterStyle,
                                    onTap: {
                                        app.setDefaultsItem(.counter, value: max(0, count - 1))
                                    }),
                                .text("Up",
                                    style: app.counterStyle,
                                    onTap: {
                                        app.setDefaultsItem(.counter, value: count + 1)
                                    })
                            ]),
                        ]
                    )
                ])
            }
        case .DefaultStore:
            vc.loadClosure = { [weak self] in
                guard let app = self else { return ViewModel.emptyModel }
                return ViewModel(style: app.modelStyle, title: title, sections: [
                    Section(
                        header: .stack([.text(title)]),
                        cells: DefaultsKey.allCases.map({ key in
                            .stack([
                                .text(key.rawValue,
                                    style: app.smallStyle),
                                .input(String(describing: app.getDefaultsItem(key)),
                                    style: app.largeStyle)
                            ], style: vertical)
                        })
                )])
            }
        case .DequeueTest:
            vc.loadClosure = {
                ViewModel(style: self.modelStyle, title: title, sections: [
                    Section(
                        header: .stack([.text(title)]),
                        cells: Array(1...100).map({ int in
                            .stack([
                                .text(String(int)),
                                .text(int % 2 == 0 ? "" : .longText)],
                                style: vertical)
                        })
                    )
                ])
            }
        case .Fonts:
            vc.loadClosure = {  [weak self] in
                guard let app = self else { return ViewModel.emptyModel }
                return ViewModel(style: app.modelStyle, title: title, sections:
                    UIFont.familyNames.filter({ $0 != "System Font" }).map({ familyName in
                        Section(
                            header: .stack([
                                .text(familyName)]
                            ),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                .stack([
                                    .text(fontName,
                                        style: TextStyle(font: UIFont.init(name: fontName, size: app.style.size)),
                                        onTap: {
                                            app.style = .init(name: fontName, size: app.style.size)
                                        }
                                    )
                                ])
                            })
                        )
                    })
                )
            }
        case .Login:
            vc.loadClosure = {  [weak self] in
                guard let app = self else { return ViewModel.emptyModel }
                return ViewModel(style: app.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text("\n"),
                                .input(app.getDefaultsItem(.username) as? String ?? "",
                                    placeholder: "User",
                                    style: app.hugeStyle,
                                    onSet: { string in
                                        app.setDefaultsItem(.username, value: string)
                                    }),
                                .input(app.getDefaultsItem(.password) as? String ?? "",
                                    isSecure: true,
                                    placeholder: "Password",
                                    style: app.hugeStyle,
                                    onSet: { string in
                                        app.setDefaultsItem(.password, value: string)
                                    }),
                                .text("forgot password?",
                                    style: app.smallStyle.withAlignment(.center),
                                    onTap: {
                                    }),
                                ], style: vertical),
                        ]
                    )
                ])
            }
        }
        return vc
    }
}
