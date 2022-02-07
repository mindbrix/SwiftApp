//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation

enum CellType: CaseIterable {
    case base
    var cellClass: AnyClass { TableViewCell.self }
    var reuseID: String { String(describing: cellClass) }
}

enum Cell: Hashable {
    case button(title: String, onTap: (() -> Void))
    case standard(title: String, body: String? = nil, onTap: (() -> Void)? = nil)
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
        switch self {
        case .button(let title, _):
            hasher.combine(title)
        case .standard(let title, let body, _):
            hasher.combine(title)
            hasher.combine(body)
        }
    }
    var type: CellType { .base }
}

struct Section {
    let header: Cell
    let cells: [Cell]
}

struct ViewModel {
    let title: String
    let sections: [Section]
    
    static let emptyModel = Self(title: "", sections: [])
}
