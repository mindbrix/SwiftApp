//
//  Style.swift
//  SwiftApp
//
//  Created by Nigel Barber on 15/02/2022.
//

import Foundation
import UIKit

struct StackStyle: Equatable {
    let axis: NSLayoutConstraint.Axis
    let alignment: UIStackView.Alignment?
    let distribution: UIStackView.Distribution?
    let insets: UIEdgeInsets?
    let spacing: CGFloat?
    
    init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil,
        insets: UIEdgeInsets? = nil,
        spacing: CGFloat? = nil) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.insets = insets
        self.spacing = spacing
    }
    
    func withAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return Self(axis: axis, alignment: alignment, distribution: distribution, insets: insets, spacing: spacing)
    }
    func withAlignment(_ alignment: UIStackView.Alignment) -> Self {
        return Self(axis: axis, alignment: alignment, distribution: distribution, insets: insets, spacing: spacing)
    }
    func withDistribution(_ distribution: UIStackView.Distribution) -> Self {
        return Self(axis: axis, alignment: alignment, distribution: distribution, insets: insets, spacing: spacing)
    }
    func withInsets(_ insets: UIEdgeInsets?) -> Self {
        return Self(axis: axis, alignment: alignment, distribution: distribution, insets: insets, spacing: spacing)
    }
    func withSpacing(_ spacing: CGFloat) -> Self {
        return Self(axis: axis, alignment: alignment, distribution: distribution, insets: insets, spacing: spacing)
    }
}
