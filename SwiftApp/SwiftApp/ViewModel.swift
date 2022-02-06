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

struct ViewModel {
    let sections: [Section]
    
    static let emptyModel = ViewModel(sections: [])
}
