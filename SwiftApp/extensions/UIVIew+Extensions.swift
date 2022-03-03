//
//  UIView+Extensions.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - Auto Layout
    
    func edgeConstraints(for subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ]
    }
    
    func underlineConstraints(for subview: UIView, height: CGFloat = 0.5) -> [NSLayoutConstraint] {
        [
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.heightAnchor.constraint(equalToConstant: height)
        ]
    }
    
    
    // MARK: - Animation
    
    func fadeToBackground(from color: UIColor?, duration: TimeInterval = 0.66) {
        guard let color = color
        else { return }

        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = color.cgColor
        animation.toValue = backgroundColor?.cgColor
        animation.duration = duration
        animation.repeatCount = 1
        layer.add(animation, forKey: #keyPath(CALayer.backgroundColor))
    }
    
    
    // MARK: - Text sizing
    
    func textSize(for text: String?, font: UIFont?, width: CGFloat) -> CGSize {
        guard let font = font,
              let text = text,
              width > 0
        else {
            return .zero
        }
        
        let size = (text as NSString).boundingRect(
            with: CGSize(
                width: width,
                height: .greatestFiniteMagnitude
            ),
            options: [
                .usesLineFragmentOrigin,
            ],
            attributes: [
                NSAttributedString.Key.font: font
            ],
            context: nil).size
        
        return CGSize(
            width: ceil(contentScaleFactor * size.width) / contentScaleFactor,
            height: ceil(contentScaleFactor * size.height) / contentScaleFactor
        )
    }
}
