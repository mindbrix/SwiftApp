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
    let spacing: CGFloat
    
    init(color: UIColor = .white, isVertical: Bool = false, insets: UIEdgeInsets? = nil, spacing: CGFloat = 4) {
        self.color = color
        self.isVertical = isVertical
        self.insets = insets
        self.spacing = spacing
    }
    
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, isVertical: isVertical, insets: insets, spacing: spacing)
    }
    func withInsets(_ insets: UIEdgeInsets?) -> Self {
        return Self(color: color, isVertical: isVertical, insets: insets, spacing: spacing)
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
    let showIndex: Bool
    
    init(cell: CellStyle = .init(), text: TextStyle = .init(), showIndex: Bool = false) {
        self.cell = cell
        self.text = text
        self.showIndex = showIndex
    }
    
    func withShowIndex() -> Self {
        Self(cell: cell, text: text, showIndex: true)
    }
}
