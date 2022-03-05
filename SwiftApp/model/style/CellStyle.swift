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
    let underline: UIColor?
    let stackStyle: StackStyle
    
    init(color: UIColor = .white, underline: UIColor? = nil, stackStyle: StackStyle = .init()) {
        self.color = color
        self.underline = underline
        self.stackStyle = stackStyle
    }
    
    func withColor(_ color: UIColor) -> Self {
        return Self(color: color, underline: underline, stackStyle: stackStyle)
    }
    func withUnderline(_ underline: UIColor?) -> Self {
        return Self(color: color, underline: underline, stackStyle: stackStyle)
    }
    func withStackStyle(_ stackStyle: StackStyle) -> Self {
        return Self(color: color, underline: underline, stackStyle: stackStyle)
    }
}
