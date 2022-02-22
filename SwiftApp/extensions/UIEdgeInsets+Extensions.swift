//
//  UIEdgeInsets+Extensions.swift
//  SwiftApp
//
//  Created by Nigel Barber on 19/02/2022.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    init(spacing: CGFloat) {
        self.init(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    var directionalInsets: NSDirectionalEdgeInsets {
        .init(
            top: top,
            leading: left,
            bottom: bottom,
            trailing: right
        )
    }
}
