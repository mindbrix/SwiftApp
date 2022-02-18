//
//  StyleCache.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation
import UIKit

class StyleCache {
    init() {
        updateStyles()
    }
    
    var didUpdate: (() -> Void)?

    var name = "HelveticaNeue" {
        didSet {
            guard name != oldValue else { return }
            updateStyles()
            didUpdate?()
        }
    }
    var size: CGFloat = 18 {
        didSet {
            guard size != oldValue else { return }
            updateStyles()
            didUpdate?()
        }
    }
    var smallStyle = TextStyle()
    var defaultStyle = TextStyle()
    var largeStyle = TextStyle()
    var hugeStyle = TextStyle()
    var counterStyle = TextStyle()
    var modelStyle = ModelStyle()
    var minusImage = UIImage()
    var plusImage = UIImage()
    
    private func updateStyles() {
        let smallFont = UIFont(name: name, size: size * 0.86)
        let defaultFont = UIFont(name: name, size: size)
        let largeFont = UIFont(name: name, size: size * 1.2)
        let hugeFont = UIFont(name: name, size: size * 1.6)
        
        smallStyle = .init(color: .gray, font: smallFont)
        defaultStyle = .init(font: defaultFont)
        largeStyle = .init(font: largeFont)
        hugeStyle = .init(font: hugeFont, alignment: .center)
        counterStyle = .init(font: largeFont, alignment: .center)
        modelStyle = .init(text: defaultStyle)
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
        minusImage = UIImage(
            systemName: "minus.circle",
            withConfiguration: config
        ) ?? UIImage()
        plusImage = UIImage(
            systemName: "plus.circle",
            withConfiguration: config
        ) ?? UIImage()
    }
}