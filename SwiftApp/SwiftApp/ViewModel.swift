//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation

enum Cell {
    case button(title: String, onTap: (() -> Void))
    case standard(title: String, body: String? = nil, onTap: (() -> Void)? = nil)
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
