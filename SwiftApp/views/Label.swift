//
//  Label.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation
import UIKit


class Label: UILabel, AtomAView {
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .text(let string, let style, _):
            let textStyle = style ?? modelStyle.text
            text = string
            font = textStyle.font
            textAlignment = textStyle.alignment
            textColor = textStyle.color
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(frame.size)
        print(textSize)
    }
    
    var textSize: CGSize {
        guard let font = font,
              let text = text,
              frame.size.width > 0 &&
                frame.size.height > 0
        else { return .zero }
        
        let scale = contentScaleFactor
        let size = (text as NSString).boundingRect(
            with: CGSize(
                width: frame.size.width,
                height: .greatestFiniteMagnitude),
            options: [
//                .usesFontLeading,
                .usesLineFragmentOrigin,
            ],
            attributes: [
                NSAttributedString.Key.font: font
            ],
            context: nil).size
        
        return CGSize(
            width: ceil(scale * size.width) / scale,
            height: ceil(scale * size.height) / scale)
    }
}
