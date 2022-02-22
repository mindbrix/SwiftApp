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

struct Cell: Equatable {
    enum Axis {
        case horizontal
        case vertical
    }
    
    let atoms: [Atom]
    let style: CellStyle?
    let axis: Axis
    
    init(_ atom: Atom, style: CellStyle? = nil) {
        self.init([atom], style: style)        
    }
    init(_ atoms: [Atom], axis: Axis = .horizontal, style: CellStyle? = nil) {
        self.atoms = atoms
        self.axis = axis
        self.style = style
    }
}

struct Section: Equatable {
    let header: Cell?
    let cells: [Cell]
}


class ViewModel: Equatable {
    let style: ModelStyle
    let title: String
    let sections: [Section]
    
    init(style: ModelStyle = .init(), title: String = "", sections: [Section] = []) {
        self.style = style
        self.title = title
        self.sections = sections
    }
    
    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.style == rhs.style &&
        lhs.title == rhs.title &&
        lhs.sections == rhs.sections
    }
    
    typealias Closure = () -> ViewModel?
}
