//
//  UIEdgeInsets+spacing.swift
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
}
