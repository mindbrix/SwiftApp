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
    
    func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak self, weak app] in
            guard let self = self,
                    let app = app
            else { return nil }
            
            return ViewModel(style: self.modelStyle, title: "Style", sections: [
                Section(
                    header: Cell(
                        .text(self.name,
                            style: self.modelStyle.text.withAlignment(.center),
                            onTap: {
                                app.push(.Fonts)
                            })
                    ),
                    cells: [
                        Cell([
                            .image(self.minusImage,
                                onTap: {
                                    self.size = max(4, self.size - 1)
                                }
                            ),
                            .text("\(self.size)",
                                style: self.counterStyle
                            ),
                            .image(self.plusImage,
                                onTap: {
                                    self.size = self.size + 1
                                }
                            )
                        ]),
                        Cell([
                            .image(self.minusImage,
                                onTap: {
                                    self.spacing = max(0, self.spacing - 1)
                                }
                            ),
                            .text("\(self.spacing)",
                                style: self.counterStyle
                            ),
                            .image(self.plusImage,
                                onTap: {
                                    self.spacing = self.spacing + 1
                                }
                            )
                        ]),
                        Cell(
                            .text("Underline: " + (self.underline == nil ? "Off" : "On"),
                                  style: self.modelStyle.text.withAlignment(.center),
                                onTap: {
                                    self.underline = self.underline == nil ? .gray : nil
                                }
                            )
                        ),
                        Cell(
                            .text("Show Refresh: " + (self.showRefresh ? "On" : "Off"),
                                  style: self.modelStyle.text.withAlignment(.center),
                                onTap: {
                                    self.showRefresh = !self.showRefresh
                                }
                            )
                        ),
                    ]
                    )
                ])
        }
    }
    
    func fontsClosure() -> ViewModel.Closure {
        { [weak self] in
            guard let self = self
            else { return nil }
            
            return ViewModel(style: self.modelStyle.withShowIndex(), title: "Fonts", sections:
                UIFont.familyNames.filter({ $0 != "System Font" }).map({ familyName in
                    Section(
                        header: Cell(
                            .text(familyName)
                        ),
                        cells: UIFont.fontNames(forFamilyName: familyName).map({ fontName in
                            Cell(
                                .text(fontName,
                                    style: TextStyle(
                                        font: UIFont(
                                            name: fontName,
                                            size: self.size
                                        )
                                    ),
                                    onTap: {
                                        self.name = fontName
                                    }
                                )
                            )
                        })
                    )
                })
            )
        }
    }
}
