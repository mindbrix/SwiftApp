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
    
    static let emptyModel = Self(sections: [])
    static let fullModel = Self(sections: [
        Section(title: "Section 1", cells: [
            .standard(title: "Title", body: "Body")
        ])
    ])
}
