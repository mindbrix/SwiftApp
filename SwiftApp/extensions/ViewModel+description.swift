//
//  ViewModel+description.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation

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
                        case .stack(let atoms, let style):
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
