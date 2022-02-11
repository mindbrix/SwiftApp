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
    case image(get: () -> UIImage?, width: CGFloat? = nil, onTap: (() -> Void)? = nil)
    case input(get: () -> String, set: ((String) -> Void)? = nil, scale: CGFloat = 100)
    
    static func == (lhs: Atom, rhs: Atom) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
        switch self {
        case .image(let get, _, _):
            hasher.combine(get())
        case .input(let get, _, _):
            hasher.combine(get())
        default:
            break
        }
    }
}

enum Cell: Hashable {
    case cell(_ atoms: [Atom], isVertical: Bool = false)
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
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
