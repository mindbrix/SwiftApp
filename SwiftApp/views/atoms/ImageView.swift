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
    
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) -> Bool {
        switch atom {
        case .image(let image, let style, _):
            self.image = image
            contentMode = .scaleAspectFit
            heightConstraint?.isActive = false
            
            let size = image.size
            guard size.height > 0 && size.width > 0
            else { return false }
            
            let imageStyle = style ?? modelStyle.image
            let aspect = size.height / size.width
            var height: CGFloat = .greatestFiniteMagnitude
            
            if let width = imageStyle.width {
                height = width * aspect
                heightConstraint = heightAnchor.constraint(
                    lessThanOrEqualToConstant: height)
                heightConstraint?.isActive = true
                widthConstraint.constant = width
                widthConstraint.isActive = true
            } else {
                let baseWidth = min(size.width, frame.size.width) 
                height = frame.size.width == 0 ? .greatestFiniteMagnitude : baseWidth * aspect
                heightConstraint = heightAnchor.constraint(
                    lessThanOrEqualTo: widthAnchor,
                    multiplier: aspect
                )
                heightConstraint?.priority = .required
                heightConstraint?.isActive = true
                widthConstraint.isActive = false
            }

            if image.isSymbolImage {
                tintColor = imageStyle.color
            }
            let willResize = frame.size.height < height
            return willResize
        default:
            return false
        }
    }
}
