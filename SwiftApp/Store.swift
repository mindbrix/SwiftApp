//
//  Store.swift
//  SwiftApp
//
//  Created by Nigel Barber on 17/02/2022.
//

import Foundation
import UIKit


class Store {
    enum Key: String, CaseIterable {
        case counter
        case fontName
        case fontSize
        case password
        case spacing
        case underline
        case username
        case weatherCity
    }
    
    var onDidUpdate: (() -> Void)?
    
    func get(_ key: Key) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }

    func set(_ key: Key, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
        onDidUpdate?()
    }
    
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                  let store = app?.store
            else { return nil }
            
            let title = Screen.DefaultStore.rawValue
            
            return ViewModel(style: cache.modelStyle, title: title, sections: [
                Section(
                    header: Cell(.text(title)),
                    cells: Store.Key.allCases.sorted(by: { $0.rawValue < $1.rawValue }).map({ key in
                        Cell([
                            .text(key.rawValue + ": ",
                                style: cache.largeStyle.withColor(.gray)
                            ),
                            .text(String(describing: store.get(key)),
                                style: cache.largeStyle.withAlignment(.right)
                            )],
                            style: cache.modelStyle.cell
                                .withStackStyle(.init(alignment: .leading, insets: .init(spacing: 8)))
                                .withUnderline(.gray)
                        )
                    })
                )
            ])
        }
    }
}
