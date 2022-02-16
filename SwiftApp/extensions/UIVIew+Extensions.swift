//
//  UIView+Extensions.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

extension UIView {
    func addUnderlineConstraints(_ separator: UIView, height: CGFloat = 0.5) {
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func edgeConstraints(for subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
    }
    
    func fadeToBackground(from color: UIColor, duration: TimeInterval = 0.66) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = color.cgColor
        animation.toValue = backgroundColor?.cgColor
        animation.duration = duration
        animation.repeatCount = 1
        layer.add(animation, forKey: #keyPath(CALayer.backgroundColor))
    }
}
