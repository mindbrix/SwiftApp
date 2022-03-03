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
    case Fonts
    case Login
    case Style
    case WeatherMain
    case WeatherCities
    
    
    var embedInNavController: Bool { self == .Main }
    
    func modelClosure(app: SwiftApp) -> ViewModel.Closure {
        let title = self.rawValue
        let grab0 = UIImage(named: "grab0") ?? UIImage()
        
        switch self {
        case .Main:
            return { [weak app] in
                guard let cache = app?.styleCache,
                        let network = app?.network,
                        let app = app
                else { return nil }
                
                let imageURL = URL(string: "https://frame.ai/images/tour-early-warning@2x.png")
                let image = network.getImage(imageURL)
        
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: Cell(.text("Menu")),
                        cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ menuScreen in
                            Cell(.text(menuScreen.rawValue,
                                       style: cache.modelStyle.text.withColor(.blue),
                                    onTap: {
                                        app.push(menuScreen)
                                    }
                                )
                            )
                        })
                    ),
                    Section(
                        header: Cell(.text("Images")),
                        cells: [
                            Cell([
                                .image(image ?? grab0,
                                    onTap: {
                                        print("grab0")
                                    }
                                ),
                                .text(.longText,
                                    style: cache.smallStyle
                                )],
                                axis: .vertical
                            ),
                            Cell([
                                .image(grab0,
                                    style: cache.modelStyle.image.withWidth(64),
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
                
                let count = store.getInt(.counter)
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            Cell(.text(String(count),
                                    style: cache.hugeStyle)
                            ),
                            Cell([
                                .text("Down",
                                    style: cache.counterStyle.withColor(.blue),
                                    onTap: {
                                        store.set(.counter, value: max(0, count - 1))
                                    }
                                ),
                                .text("Up",
                                    style: cache.counterStyle.withColor(.blue),
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
            return Store.mainClosure(app: app)
        case .Fonts:
            return app.styleCache.fontsClosure()
        case .Login:
            return { [weak app] in
                guard let cache = app?.styleCache, let store = app?.store
                else { return nil }
                
                let username = store.getString(.username)
                let password = store.getString(.password)
                let canLogin = username.count > 0 && password.count > 6
                
                return ViewModel(style: cache.modelStyle, title: title, sections: [
                    Section(
                        header: nil,
                        cells: [
                            Cell(.text("\n")),
                            Cell(.input(username,
                                    placeholder: "User",
                                    style: cache.hugeStyle,
                                    onSet: { string in
                                        store.set(.username, value: string)
                                    }
                                )
                            ),
                            Cell(.input(password,
                                    isSecure: true,
                                    placeholder: "Password",
                                    style: cache.hugeStyle,
                                    onSet: { string in
                                        store.set(.password, value: string)
                                    }
                                )
                            ),
                            Cell(.text("forgot password?",
                                    style: cache.smallStyle.withColor(.blue).withAlignment(.center),
                                    onTap: {
                                    }
                                )
                            ),
                            Cell(.text("\n")),
                            Cell(.text("Login",
                                    style: cache.hugeStyle.withColor(canLogin ? .blue : .gray).withAlignment(.center),
                                    onTap: {
                                    }
                                )
                            ),
                        ]
                    )
                ])
            }
        case .Style:
            return app.styleCache.mainClosure(app: app)
        case .WeatherMain:
            return Weather.mainClosure(app: app)
        case .WeatherCities:
            return Weather.citiesClosure(app: app)
        }
    }
}
