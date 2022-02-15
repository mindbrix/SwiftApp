//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


enum Atom: Hashable {
    struct TextStyle {
        let scale: CGFloat
        let alignment: NSTextAlignment
        init(scale: CGFloat = 100, alignment: NSTextAlignment = .left) {
            self.scale = scale
            self.alignment = alignment
        }
    }
    case text(_ string: String, style: TextStyle? = nil, onTap: (() -> Void)? = nil)
    case image(url: String, width: CGFloat? = nil, onTap: (() -> Void)? = nil)
    case input(value: String, style: TextStyle? = nil, onSet: ((String) -> Void)? = nil)
    
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

struct FontStyle: Equatable {
    let name: String
    let size: CGFloat
    
    static let defaultStyle = Self(name: "HelveticaNeue", size: 18)
}

struct ViewModel: Equatable {
    let style: FontStyle
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(style: .defaultStyle, title: "", sections: [])
    
    typealias Closure = () -> ViewModel
}
