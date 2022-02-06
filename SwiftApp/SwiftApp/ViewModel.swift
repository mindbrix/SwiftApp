//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation

enum Cell {
    case standard(title: String, body: String?)
}

struct Section {
    let title: String
    let cells: [Cell]
}

struct Model {
    let sections: [Model]
    
    static let emptyModel = Model(sections: [])
}
