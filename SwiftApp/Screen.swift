//
//  Screen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 17/02/2022.
//

import Foundation

enum Screen: String, CaseIterable {
    case Main
    case Counter
    case DefaultStore
    case DequeueTest
    case Fonts
    case Login
    
    var embedInNavController: Bool { self == .Main }
    
    func modelClosure() -> ViewModel.Closure {
        { ViewModel.emptyModel }
    }
}
