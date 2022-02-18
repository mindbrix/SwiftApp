//
//  Style.swift
//  SwiftApp
//
//  Created by Nigel Barber on 15/02/2022.
//

import Foundation
import UIKit


struct CellStyle: Equatable {
    let color: UIColor
    let isVertical: Bool
    let insets: UIEdgeInsets?
    
    init(color: UIColor = .white, isVertical: Bool = false, insets: UIEdgeInsets? = nil) {
        self.color = color
        self.isVertical = isVertical
        self.insets = insets
    }
    
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, isVertical: isVertical, insets: insets)
    }
}

struct TextStyle: Equatable {
    let color: UIColor
    let font: UIFont?
    let alignment: NSTextAlignment
    
    init(color: UIColor = .black, font: UIFont? = nil, alignment: NSTextAlignment = .left) {
        self.color = color
        self.font = font
        self.alignment = alignment
    }
    
    func withAlignment(_ alignment: NSTextAlignment) -> Self {
        return Self(color: color, font: font, alignment: alignment)
    }
}

struct ModelStyle: Equatable {
    let cell: CellStyle
    let text: TextStyle

    init(cell: CellStyle = .init(), text: TextStyle = .init()) {
        self.cell = cell
        self.text = text
    }
    static let spacing: CGFloat = 4
    static let defaultInsets = UIEdgeInsets(
        top: Self.spacing,
        left: Self.spacing,
        bottom: Self.spacing,
        right: Self.spacing
    )
}
