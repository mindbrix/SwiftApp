//
//  Label.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation
import UIKit

class Label: UILabel, AtomAView {
    func apply(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .text(let string, let style, let onTap):
            let textStyle = style ?? modelStyle.text
            text = string
            font = textStyle.font
            textAlignment = textStyle.alignment
            textColor = onTap == nil ? textStyle.color : .blue
        default:
            break
        }
    }
}
