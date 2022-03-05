//
//  Style.swift
//  SwiftApp
//
//  Created by Nigel Barber on 15/02/2022.
//

import Foundation
import UIKit


struct ModelStyle: Equatable {
    let cell: CellStyle
    let image: ImageStyle
    let text: TextStyle
    let showIndex: Bool
    let showRefresh: Bool
    
    
    init(cell: CellStyle = .init(), image: ImageStyle = .init(), text: TextStyle = .init(), showIndex: Bool = false, showRefresh: Bool = false) {
        self.cell = cell
        self.image = image
        self.text = text
        self.showIndex = showIndex
        self.showRefresh = showRefresh
    }
    
    func withShowIndex() -> Self {
        Self(cell: cell, image: image, text: text, showIndex: true, showRefresh: showRefresh)
    }
    func withShowRefresh() -> Self {
        Self(cell: cell, image: image, text: text, showIndex: showIndex, showRefresh: true)
    }
}
