//
//  Screen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 17/02/2022.
//

import Foundation
import UIKit

enum Screen: String, CaseIterable {
    case Main
    case Counter
    case DefaultStore
    case DequeueTest
    case Fonts
    case Login
    
    var embedInNavController: Bool { self == .Main }
    
    func modelClosure(app: SwiftApp) -> ViewModel.Closure {
        let title = self.rawValue
        let grab0 = UIImage(named: "grab0") ?? UIImage()
        
        switch self {
        case .Main:
            return { [weak app] in
                guard let cache = app?.styleCache, let app = app
                else { return nil }
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: Cell(
                            .text(cache.name,
                                style: cache.defaultStyle.withAlignment(.center),
                                onTap: {
                                    app.push(.Fonts)
                                })
                        ),
                        cells: [
                            Cell([
                                .image(cache.minusImage,
                                    width: cache.size,
                                    onTap: {
                                        app.styleCache.size = max(4, cache.size - 1)
                                    }
                                ),
                                .text("\(cache.size)",
                                    style: cache.counterStyle
                                ),
                                .image(cache.plusImage,
                                    width: cache.size,
                                    onTap: {
                                        app.styleCache.size = cache.size + 1
                                    }
                                )
                            ]),
                        ]),
                    Section(
                        header: Cell(.text("Menu")),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ menuScreen in
                            Cell(.text(menuScreen.rawValue,
                                    onTap: {
                                        app.push(menuScreen)
                                    }
                                ),
                                style: cache.modelStyle.cell.withInsets(.init(spacing: 8))
                            )
                        })
                    ),
                    Section(
                        header: Cell(.text("Images")),
                        cells: [
                            Cell([
                                .image(grab0,
                                    onTap: {
                                        print("grab0")
                                    }
                                ),
                                .text(.longText,
                                    style: cache.smallStyle
                                )],
                                style: cache.modelStyle.cell.withVertical()
                            ),
                            Cell([
                                .image(grab0,
                                    width: 64,
                                    onTap: {
                                        print("grab0")
                                    }
                                ),
                                .text(.longText,
                                    style: cache.smallStyle
                                ),
                            ]),
                        ])
                ])
            }
        case .Counter:
            return { [weak app] in
                guard let cache = app?.styleCache, let store = app?.store
                else { return nil }
                
                let count = store.get(.counter) as? Int ?? 0
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            Cell(.text(String(count),
                                    style: cache.hugeStyle)
                            ),
                            Cell([
                                .text("Down",
                                    style: cache.counterStyle,
                                    onTap: {
                                        store.set(.counter, value: max(0, count - 1))
                                    }
                                ),
                                .text("Up",
                                    style: cache.counterStyle,
                                    onTap: {
                                        store.set(.counter, value: count + 1)
                                    }
                                )
                            ]),
                        ]
                    )
                ])
            }
        case .DefaultStore:
            return { [weak app] in
                guard let cache = app?.styleCache, let store = app?.store
                else { return nil }
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: Cell(.text(title)),
                        cells: Store.Key.allCases.map({ key in
                            Cell([
                                .text(key.rawValue,
                                    style: cache.smallStyle
                                ),
                                .input(String(describing: store.get(key)),
                                    style: cache.largeStyle
                                )],
                                style: cache.modelStyle.cell.withVertical()
                            )
                        })
                    )
                ])
            }
        case .DequeueTest:
            return { [weak app] in
                guard let cache = app?.styleCache
                else { return nil }
            
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: Cell(.text(title)),
                        cells: Array(1...100).map({ int in
                            Cell([
                                .text(String(int)),
                                .text(int % 2 == 0 ? "" : .longText)
                                ],
                                style: cache.modelStyle.cell.withVertical()
                            )
                        })
                    )
                ])
            }
        case .Fonts:
            return {  [weak app] in
                guard let cache = app?.styleCache, let app = app
                else { return nil }
                
                return ViewModel(style: cache.modelStyle.withShowIndex(), title: title, sections:
                    UIFont.familyNames.filter({ $0 != "System Font" }).map({ familyName in
                        Section(
                            header: Cell(.text(familyName)),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                Cell(.text(fontName,
                                    style: TextStyle(
                                        font: UIFont.init(
                                            name: fontName,
                                            size: cache.size
                                        )
                                    ),
                                    onTap: {
                                        app.styleCache.name = fontName
                                    })
                                )
                            })
                        )
                    })
                )
            }
        case .Login:
            return {  [weak app] in
                guard let cache = app?.styleCache, let store = app?.store
                else { return nil }
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            Cell([
                                .text("\n"),
                                .input(store.get(.username) as? String ?? "",
                                    placeholder: "User",
                                    style: cache.hugeStyle,
                                    onSet: { string in
                                        store.set(.username, value: string)
                                    }
                                ),
                                .input(store.get(.password) as? String ?? "",
                                    isSecure: true,
                                    placeholder: "Password",
                                    style: cache.hugeStyle,
                                    onSet: { string in
                                        store.set(.password, value: string)
                                    }
                                ),
                                .text("forgot password?",
                                    style: cache.smallStyle.withAlignment(.center),
                                    onTap: {
                                    }
                                )],
                                style: cache.modelStyle.cell.withVertical()
                            ),
                        ]
                    )
                ])
            }
        }
    }
}
