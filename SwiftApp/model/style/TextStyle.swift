//
//  Style.swift
//  SwiftApp
//
//  Created by Nigel Barber on 15/02/2022.
//

import Foundation
import UIKit


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
