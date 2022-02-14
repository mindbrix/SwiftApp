//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

class ImageView: UIImageView {
    func setAspectImage(_ image: UIImage?, width: CGFloat? = nil) {
        self.image = image
        heightConstraint = nil
        if let size = image?.size {
            heightConstraint = heightAnchor.constraint(
                lessThanOrEqualTo: widthAnchor,
                multiplier: size.height / size.width)
            heightConstraint?.isActive = true
        }
        widthConstraint.constant = width ?? 0
        widthConstraint.isActive = width != nil
    }
    var heightConstraint: NSLayoutConstraint?
    lazy var widthConstraint: NSLayoutConstraint = {
        widthAnchor.constraint(equalToConstant: 0)
    }()
}
