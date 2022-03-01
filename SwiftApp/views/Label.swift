//
//  Label.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation
import UIKit


class Label: UILabel, AtomAView {
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) -> Bool {
        switch atom {
        case .text(let string, let style, _):
            let textStyle = style ?? modelStyle.text
            text = string
            font = textStyle.font
            textAlignment = textStyle.alignment
            textColor = textStyle.color
            
            let width = frame.size.width == 0 ? .greatestFiniteMagnitude : frame.size.width
            let textSize = textSize(
                for: text,
                font: font,
                width: width)
            let willResize = frame.size.height != textSize.height
            return willResize
        default:
            return false
        }
    }
}
