//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

enum CellClass: CaseIterable {
    case base
    var cellClass: AnyClass { UITableViewCell.self }
    var reuseID: String { String(describing: cellClass) }
}

enum Cell {
    case button(title: String, onTap: (() -> Void))
    case standard(title: String, body: String? = nil, onTap: (() -> Void)? = nil)
    
    var cellClass: CellClass { .base }
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
