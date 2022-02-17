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
        let vertical: CellStyle = .init(isVertical: true)
        
        switch self {
        case .Main:
            return { [weak app] in
                guard let app = app else {
                    return ViewModel.emptyModel
                }
                let style = app.style 
                let name = style.style.name, size = style.style.size
                return ViewModel(style: style.modelStyle, title: title, sections: [
                    Section(
                        header: .stack([
                            .text(style.style.name, style: .init(alignment: .center), onTap: {
                                app.push(.Fonts)
                            }),
                        ]),
                        cells: [
                            .stack([
                                .image(style.minusImage, width: size, onTap: {
                                    app.style.style = .init(name: name, size: max(4, size - 1))
                                }),
                                .text("\(size)", style: style.counterStyle),
                                .image(style.plusImage, width: size, onTap: {
                                    app.style.style = .init(name: name, size: size + 1)
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
                                .text(.longText, style: style.smallStyle)
                            ], style: vertical),
                            .stack([
                                .image(grab0, width: 64, onTap: { print("grab0") }),
                                .text(.longText, style: style.smallStyle),
                            ]),
                        ])
                ])
            }
        case .Counter:
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                let style = app.style
                let count = app.getDefaultsItem(.counter) as? Int ?? 0
                
                return ViewModel(style: style.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text(String(count),
                                    style: style.hugeStyle)]),
                            .stack([
                                .text("Down",
                                    style: style.counterStyle,
                                    onTap: {
                                        app.setDefaultsItem(.counter, value: max(0, count - 1))
                                    }),
                                .text("Up",
                                    style: style.counterStyle,
                                    onTap: {
                                        app.setDefaultsItem(.counter, value: count + 1)
                                    })
                            ]),
                        ]
                    )
                ])
            }
        case .DefaultStore:
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                let style = app.style
                return ViewModel(style: style.modelStyle, title: title, sections: [
                    Section(
                        header: .stack([.text(title)]),
                        cells: DefaultsKey.allCases.map({ key in
                            .stack([
                                .text(key.rawValue,
                                    style: style.smallStyle),
                                .input(String(describing: app.getDefaultsItem(key)),
                                    style: style.largeStyle)
                            ], style: vertical)
                        })
                )])
            }
        case .DequeueTest:
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                let style = app.style
                return ViewModel(style: style.modelStyle, title: title, sections: [
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
            return {  [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                let style = app.style
                return ViewModel(style: style.modelStyle, title: title, sections:
                    UIFont.familyNames.filter({ $0 != "System Font" }).map({ familyName in
                        Section(
                            header: .stack([
                                .text(familyName)]
                            ),
                            cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                                .stack([
                                    .text(fontName,
                                        style: TextStyle(font: UIFont.init(name: fontName, size: style.style.size)),
                                        onTap: {
                                            app.style.style = .init(name: fontName, size: style.style.size)
                                        }
                                    )
                                ])
                            })
                        )
                    })
                )
            }
        case .Login:
            return {  [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                let style = app.style 
                return ViewModel(style: style.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            .stack([
                                .text("\n"),
                                .input(app.getDefaultsItem(.username) as? String ?? "",
                                    placeholder: "User",
                                    style: style.hugeStyle,
                                    onSet: { string in
                                        app.setDefaultsItem(.username, value: string)
                                    }),
                                .input(app.getDefaultsItem(.password) as? String ?? "",
                                    isSecure: true,
                                    placeholder: "Password",
                                    style: style.hugeStyle,
                                    onSet: { string in
                                        app.setDefaultsItem(.password, value: string)
                                    }),
                                .text("forgot password?",
                                    style: style.smallStyle.withAlignment(.center),
                                    onTap: {
                                    }),
                                ], style: vertical),
                        ]
                    )
                ])
            }
        }
    }
}
