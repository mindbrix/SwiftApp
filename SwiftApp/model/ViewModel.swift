//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit


enum Atom: Equatable {
    case text(_ string: String,
            style: TextStyle? = nil,
            onTap: (() -> Void)? = nil)
    case image(_ image: UIImage,
            style: ImageStyle? = nil,
            onTap: (() -> Void)? = nil)
    case input(_ value: String,
            isSecure: Bool = false,
            placeholder: String? = nil,
            style: TextStyle? = nil,
            onSet: ((String) -> Void)? = nil)
    
    static func == (lhs: Atom, rhs: Atom) -> Bool {
        switch lhs {
        case .text(let lstring, let lstyle, let lonTap):
            switch rhs {
            case .text(let rstring, let rstyle, let ronTap):
                return lonTap == nil && ronTap == nil &&
                        lstring == rstring && lstyle == rstyle
            default:
                return false
            }
        case .image(let limage, let lstyle, let lonTap):
            switch rhs {
            case .image(let rimage, let rstyle, let ronTap):
                return lonTap == nil && ronTap == nil &&
                        limage == rimage && lstyle == rstyle
            default:
                return false
            }
        case .input(let lvalue, let lisSecure, let lplaceholder, let lstyle, let lonSet):
            switch rhs {
            case .input(let rvalue, let risSecure, let rplaceholder, let rstyle, let ronSet):
                return lonSet == nil && ronSet == nil &&
                        lvalue == rvalue && lisSecure == risSecure &&
                        lplaceholder == rplaceholder && lstyle == rstyle
            default:
                return false
            }
        }
    }
}

struct Cell: Equatable, Hashable {
    let atoms: [Atom]
    let style: CellStyle?
    
    init(_ atom: Atom, style: CellStyle? = nil) {
        self.init([atom], style: style)        
    }
    
    init(_ atoms: [Atom], style: CellStyle? = nil) {
        self.atoms = atoms
        self.style = style
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
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
