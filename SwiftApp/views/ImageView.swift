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
        widthAnchor.constraint(lessThanOrEqualToConstant: 0)
    }()
    
    func apply(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .image(let image, let width, let onTap):
            self.image = image
            contentMode = .scaleAspectFit
            heightConstraint?.isActive = false
            widthConstraint.isActive = false
            let size = image.size
            guard size.height > 0 && size.width > 0 else { return }
            heightConstraint = heightAnchor.constraint(
                lessThanOrEqualTo: widthAnchor,
                multiplier: size.height / size.width)
            heightConstraint?.isActive = true
            widthConstraint.constant = width ?? 0
            widthConstraint.isActive = width != nil
            
            if image.isSymbolImage {
                tintColor = onTap == nil ? modelStyle.text.color : .blue
            }
        default:
            break
        }
    }
}
