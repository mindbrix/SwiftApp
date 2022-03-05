//
//  LoginScreen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 05/03/2022.
//

import Foundation
import UIKit


struct LoginScreen {
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                    let store = app?.store
            else { return nil }
            
            let username = store.get(.username) ?? ""
            let password = store.get(.password) ?? ""
            let canLogin = username.count > 0 && password.count > 6
            
            return ViewModel(style: cache.modelStyle, title: "Login", sections: [
                Section(
                    header: nil,
                    cells: [
                        Cell(.text("\n")),
                        Cell(.input(username,
                                placeholder: "User",
                                style: cache.hugeStyle,
                                onSet: { string in
                                    store.set(string, key: .username)
                                }
                            )
                        ),
                        Cell(.input(password,
                                isSecure: true,
                                placeholder: "Password",
                                style: cache.hugeStyle,
                                onSet: { string in
                                    store.set(string, key: .password)
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
    }
}
