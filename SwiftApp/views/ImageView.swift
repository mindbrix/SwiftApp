//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit


class ImageView: UIImageView, AtomAView {
    var heightConstraint: NSLayoutConstraint?
    
    lazy var widthConstraint: NSLayoutConstraint = {
        widthAnchor.constraint(equalToConstant: 0)
    }()
    
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .image(let image, let style, _):
            self.image = image
            contentMode = .scaleAspectFit
            heightConstraint?.isActive = false
            
            let size = image.size
            guard size.height > 0 && size.width > 0
            else { return }
            
            let imageStyle = style ?? modelStyle.image
            if let width = imageStyle.width {
                heightConstraint = heightAnchor.constraint(
                    lessThanOrEqualToConstant: width * size.height / size.width)
                heightConstraint?.isActive = true
                widthConstraint.constant = width
                widthConstraint.isActive = true
            } else {
                heightConstraint = heightAnchor.constraint(
                    lessThanOrEqualTo: widthAnchor,
                    multiplier: size.height / size.width
                )
                heightConstraint?.priority = .defaultHigh
                heightConstraint?.isActive = true
                widthConstraint.isActive = false
            }

            if image.isSymbolImage {
                tintColor = imageStyle.color
            }
        default:
            break
        }
    }
}
