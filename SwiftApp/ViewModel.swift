//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


enum Atom: Hashable {
    case text(_ string: String, scale: CGFloat = 100, alignment: NSTextAlignment = .left, onTap: (() -> Void)? = nil)
    case image(url: String, width: CGFloat? = nil, onTap: (() -> Void)? = nil)
    case input(get: String, set: ((String) -> Void)? = nil, scale: CGFloat = 100)
    
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
    let style: FontStyle
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(style: .defaultStyle, title: "", sections: [])
}

typealias ModelClosure = () -> ViewModel

struct FontStyle: Equatable {
    let name: String
    let size: CGFloat
    
    static let defaultStyle = Self(name: "HelveticaNeue", size: 18)
}
