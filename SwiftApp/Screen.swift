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
        
        switch self {
        case .Main:
            return MainScreen.mainClosure(app: app)
        case .Counter:
            return CounterScreen.mainClosure(app: app)
        case .DefaultStore:
            return Store.mainClosure(app: app)
        case .Fonts:
            return StyleCache.fontsClosure(app: app)
        case .Login:
            return { [weak app] in
                guard let cache = app?.styleCache, let store = app?.store
                else { return nil }
                
                let username = store.get(.username) as? String ?? ""
                let password = store.get(.password) as? String ?? ""
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
            return StyleCache.mainClosure(app: app)
        case .WeatherMain:
            return Weather.mainClosure(app: app)
        case .WeatherCities:
            return Weather.citiesClosure(app: app)
        }
    }
}
