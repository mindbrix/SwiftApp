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
                    header: Cell([.text(String(describing: section.header))]),
                    cells: section.cells.map({ cell in
                        return Cell(cell.atoms.map({ atom in
                                Atom.text("\(atom.hashValue)\n\n" + String(describing: atom))
                            }),
                            style: cell.style
                        )
                    })
                )
            })
        )
    }
}
