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
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
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
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
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
            return { [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
                return ViewModel(style: app.modelStyle, title: title, sections: [
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
            return {  [weak app] in
                guard let app = app else { return ViewModel.emptyModel }
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
    }
}
