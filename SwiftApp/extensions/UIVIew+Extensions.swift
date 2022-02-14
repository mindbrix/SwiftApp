//
//  UIView+Extensions.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

extension UIView {
    typealias ConstraintQuadtuple = (top: NSLayoutConstraint, left: NSLayoutConstraint, bottom: NSLayoutConstraint, right: NSLayoutConstraint)
    
    func constraintsToView(_ view: UIView, insets: UIEdgeInsets = .zero) -> ConstraintQuadtuple {
        (
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
        )
    }
    
    func constrainToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        let quadtuple = constraintsToView(superview, insets: insets)
        NSLayoutConstraint.activate([quadtuple.top, quadtuple.left, quadtuple.bottom, quadtuple.right])
    }
    
    func fadeToBackground(from color: UIColor, duration: TimeInterval = 0.66) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = color.cgColor
        animation.toValue = backgroundColor?.cgColor
        animation.duration = duration
        animation.repeatCount = 1
        layer.add(animation, forKey: #keyPath(CALayer.backgroundColor))
    }
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
