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

enum Cell {
    case button(title: String, onTap: (() -> Void))
    case standard(title: String, body: String? = nil, onTap: (() -> Void)? = nil)
    
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
