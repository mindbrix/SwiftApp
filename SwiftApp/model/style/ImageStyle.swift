//
//  Style.swift
//  SwiftApp
//
//  Created by Nigel Barber on 15/02/2022.
//

import Foundation
import UIKit


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
