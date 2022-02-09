//
//  ViewModel.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import Foundation
import UIKit

enum Cell: Hashable {
    case button(title: String, onTap: (() -> Void))
    case header(caption: String)
    case image(get: () -> UIImage?, caption: String, onTap: (() -> Void)? = nil, isThumbnail: Bool = false)
    case standard(title: String, caption: String? = nil, onTap: (() -> Void)? = nil)
    case textInput(key: String, get: () -> String, set: ((String) -> Void)?)
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
        switch self {
        case .image(let get, _, _, _):
            hasher.combine(get())
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