//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


enum Atom: Hashable {
    case text(_ string: String,
            style: TextStyle? = nil,
            onTap: (() -> Void)? = nil)
    case image(_ image: UIImage,
            width: CGFloat? = nil,
            onTap: (() -> Void)? = nil)
    case input(_ value: String,
            isSecure: Bool = false,
            placeholder: String? = nil,
            style: TextStyle? = nil,
            onSet: ((String) -> Void)? = nil)
    
    static func == (lhs: Atom, rhs: Atom) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
}

enum Cell: Equatable {
    case stack(_ atoms: [Atom], style: CellStyle? = nil)
}

struct Section: Equatable {
    let header: Cell?
    let cells: [Cell]
}

struct ViewModel: Equatable {
    let style: Style
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(style: .init(), title: "", sections: [])
    
    typealias Closure = () -> ViewModel
}

extension ViewModel {
    func description() -> Self {
        Self(
            style: style,
            title: title,
            sections: sections.map({ section in
                Section(
                    header: .stack([.text(String(describing: section.header))]),
                    cells: section.cells.map({ cell in
                        switch cell {
                        case .stack(let atoms, style: let style):
                            return Cell.stack(
                                atoms.map({ atom in
                                    Atom.text("\(atom.hashValue)\n\n" + String(describing: atom))
                                }),
                                style: style
                            )
                        }
                    })
                )
            })
        )
    }
}
