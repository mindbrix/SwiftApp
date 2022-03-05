//
//  CounterScreen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 05/03/2022.
//

import Foundation
import UIKit


struct CounterScreen {
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                    let store = app?.store
            else { return nil }
            
            let count = store.get(.counter) ?? 0
            
            return ViewModel(style: cache.modelStyle, title: "Counter", sections: [
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
                                    store.set(max(0, count - 1), key: .counter)
                                }
                            ),
                            .text("Up",
                                style: cache.counterStyle.withColor(.blue),
                                onTap: {
                                    store.set(count + 1, key: .counter)
                                }
                            )
                        ]),
                    ]
                )
            ])
        }
    }
}

