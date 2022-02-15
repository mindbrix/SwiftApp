//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

struct CellStyle: Equatable {
    let color: UIColor
    let isVertical: Bool
    let insets: UIEdgeInsets?
    init(color: UIColor = .white, isVertical: Bool = false, insets: UIEdgeInsets? = nil) {
        self.color = color
        self.isVertical = isVertical
        self.insets = insets
    }
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, isVertical: isVertical, insets: insets)
    }
}

struct TextStyle: Equatable {
    let color: UIColor
    let font: UIFont?
    let alignment: NSTextAlignment
    init(color: UIColor = .black, font: UIFont? = nil, alignment: NSTextAlignment = .left) {
        self.color = color
        self.font = font
        self.alignment = alignment
    }
    func withAlignment(_ alignment: NSTextAlignment) -> Self {
        return Self(color: color, font: font, alignment: alignment)
    }
}

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
    let style: TextStyle
    let cellStyle: CellStyle
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(style: .init(), cellStyle: .init(), title: "", sections: [])
    
    typealias Closure = () -> ViewModel
}
