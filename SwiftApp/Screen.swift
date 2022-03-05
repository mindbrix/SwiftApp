//
//  Screen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 17/02/2022.
//

import Foundation
import UIKit


enum Screen: String, CaseIterable {
    case Main
    case Counter
    case DefaultStore = "Store"
    case Fonts
    case Login
    case Style
    case WeatherMain = "Weather"
    case WeatherCities = "Weather Cities"
    
    var embedInNavController: Bool { self == .Main }
    
    func modelClosure(app: SwiftApp) -> ViewModel.Closure {
        switch self {
        case .Main:
            return MainScreen.mainClosure(app: app)
        case .Counter:
            return CounterScreen.mainClosure(app: app)
        case .DefaultStore:
            return Store.mainClosure(app: app)
        case .Fonts:
            return StyleCache.fontsClosure(app: app)
        case .Login:
            return LoginScreen.mainClosure(app: app)
        case .Style:
            return StyleCache.mainClosure(app: app)
        case .WeatherMain:
            return Weather.mainClosure(app: app)
        case .WeatherCities:
            return Weather.citiesClosure(app: app)
        }
    }
}
