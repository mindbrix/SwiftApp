//
//  AtomView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 22/02/2022.
//

import Foundation

protocol AtomAView {
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) -> Bool
}
