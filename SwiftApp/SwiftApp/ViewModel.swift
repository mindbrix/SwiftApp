//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation

enum Cell: Hashable {
    case button(title: String, onTap: (() -> Void))
    case header(title: String)
    case standard(title: String, body: String? = nil, onTap: (() -> Void)? = nil)
    case textInput(title: String, get: () -> String, set: (String) -> Void)
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
        switch self {
        case .textInput(_, let get, _):
            hasher.combine(get())
        default:
            break
        }
    }
}

struct Section: Equatable {
    let header: Cell
    let cells: [Cell]
}

struct ViewModel: Equatable {
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(title: "", sections: [])
}

typealias ModelClosure = () -> ViewModel
