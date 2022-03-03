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
    let insets: UIEdgeInsets?
    let spacing: CGFloat?
    let underline: UIColor?
    
    init(color: UIColor = .white, insets: UIEdgeInsets? = nil, spacing: CGFloat? = nil, underline: UIColor? = nil) {
        self.color = color
        self.insets = insets
        self.spacing = spacing
        self.underline = underline
    }
    
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, insets: insets, spacing: spacing, underline: underline)
    }
    func withInsets(_ insets: UIEdgeInsets?) -> Self {
        return Self(color: color, insets: insets, spacing: spacing, underline: underline)
    }
    func withSpacing(_ spacing: CGFloat) -> Self {
        return Self(color: color, insets: insets, spacing: spacing, underline: underline)
    }
    func withUnderline(_ underline: UIColor?) -> Self {
        return Self(color: color, insets: insets, spacing: spacing, underline: underline)
    }
}

struct ImageStyle: Equatable {
    let color: UIColor
    let width: CGFloat?
    
    init(color: UIColor = .blue, width: CGFloat? = nil) {
        self.color = color
        self.width = width
    }
    
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, width: width)
    }
    func withWidth(_ width: CGFloat?) -> Self {
        return Self(color: color, width: width)
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
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, font: font, alignment: alignment)
    }
    func withFont(_ font: UIFont) -> Self {
        return Self(color: color, font: font, alignment: alignment)
    }
}

struct ModelStyle: Equatable {
    let cell: CellStyle
    let image: ImageStyle
    let text: TextStyle
    let showIndex: Bool
    let showRefresh: Bool
    
    
    init(cell: CellStyle = .init(), image: ImageStyle = .init(), text: TextStyle = .init(), showIndex: Bool = false, showRefresh: Bool = false) {
        self.cell = cell
        self.image = image
        self.text = text
        self.showIndex = showIndex
        self.showRefresh = showRefresh
    }
    
    func withShowIndex() -> Self {
        Self(cell: cell, image: image, text: text, showIndex: true, showRefresh: showRefresh)
    }
    func withShowRefresh() -> Self {
        Self(cell: cell, image: image, text: text, showIndex: showIndex, showRefresh: true)
    }
}
