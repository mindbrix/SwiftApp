//
//  StyleCache.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation
import UIKit


class StyleCache {
    static let symbolConfig = UIImage.SymbolConfiguration(
        pointSize: 36,
        weight: .medium)
    
    init() {
        minusImage = UIImage(
            systemName: "minus.circle",
            withConfiguration: Self.symbolConfig
        ) ?? UIImage()
        plusImage = UIImage(
            systemName: "plus.circle",
            withConfiguration: Self.symbolConfig
        ) ?? UIImage()
        
        updateStyles()
    }
    
    let minusImage: UIImage
    let plusImage: UIImage
    
    var onDidUpdate: (() -> Void)?

    var name = "HelveticaNeue" {
        didSet {
            guard name != oldValue else { return }
            updateStyles()
            onDidUpdate?()
        }
    }
    var size: CGFloat = 18 {
        didSet {
            guard size != oldValue else { return }
            updateStyles()
            onDidUpdate?()
        }
    }
    var showRefresh: Bool = true {
        didSet {
            guard oldValue != showRefresh else { return }
            updateStyles()
            onDidUpdate?()
        }
    }
    var spacing: CGFloat = 4 {
        didSet {
            guard spacing != oldValue else { return }
            updateStyles()
            onDidUpdate?()
        }
    }
    var underline: UIColor? = nil {
        didSet {
            guard underline != oldValue else { return }
            updateStyles()
            onDidUpdate?()
        }
    }
    
    var smallStyle = TextStyle()
    var largeStyle = TextStyle()
    var hugeStyle = TextStyle()
    var counterStyle = TextStyle()
    var modelStyle = ModelStyle()
    
    private func updateStyles() {
        let smallFont = UIFont(name: name, size: size * 0.86)
        let defaultFont = UIFont(name: name, size: size)
        let largeFont = UIFont(name: name, size: size * 1.2)
        let hugeFont = UIFont(name: name, size: size * 1.6)
        
        smallStyle = .init(color: .gray, font: smallFont)
        largeStyle = .init(font: largeFont)
        hugeStyle = .init(font: hugeFont, alignment: .center)
        counterStyle = .init(font: largeFont, alignment: .center)
        
        modelStyle = ModelStyle(
            cell: CellStyle(
                insets: UIEdgeInsets(spacing: spacing),
                spacing: spacing,
                underline: underline),
            text: .init(font: defaultFont),
            showRefresh: showRefresh
        )
    }
}
