//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


enum Atom: Hashable {
    case text(_ string: String, style: TextStyle? = nil, onTap: (() -> Void)? = nil)
    case image(_ image: UIImage, width: CGFloat? = nil, onTap: (() -> Void)? = nil)
    case input(_ value: String, placeholder: String? = nil, style: TextStyle? = nil, onSet: ((String) -> Void)? = nil)
    
    static func == (lhs: Atom, rhs: Atom) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
}

enum Cell: Equatable {
    case stack(_ atoms: [Atom], isVertical: Bool = false, inset: UIEdgeInsets? = nil)
}

struct Section: Equatable {
    let header: Cell?
    let cells: [Cell]
}

struct ViewModel: Equatable {
    let style: Style
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(style: .init(cell: .init(), text: .init()), title: "", sections: [])
    
    typealias Closure = () -> ViewModel
}
