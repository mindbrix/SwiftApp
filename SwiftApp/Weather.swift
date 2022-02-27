//
//  Weather.swift
//  SwiftApp
//
//  Created by Nigel Barber on 26/02/2022.
//

import Foundation
import UIKit


struct Weather: Codable {
    struct Day: Codable {
        let day: String
        let temperature: String
        let wind: String
    }
    let temperature: String
    let wind: String
    let description: String
    let forecast: [Day]
    
    static let baseURL = "https://goweather.herokuapp.com/weather/"
    
    static func url(for city: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path.append(contentsOf: city)
        return components?.url
    }
    
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                  let store = app?.store,
                    let network = app?.network,
                    let weather = network.get(
                        Weather.self,
                        from: Weather.url(for: store.getString(.weatherCity))
                    ),
                    let app = app
            else { return nil }
            
            let textStyle = cache.modelStyle.text
            let gray = textStyle.withColor(.gray)
            let center = textStyle.withAlignment(.center)
            let centerGray = textStyle.withAlignment(.center).withColor(.gray)
            let right = textStyle.withAlignment(.right)
            
            return ViewModel(style: cache.modelStyle, title: "Weather", sections: [
                Section(
                    header: Cell(
                        .text(store.getString(.weatherCity),
                            style: center.withColor(.blue),
                            onTap: {
                                app.present(.WeatherCities)
                            })
                    ),
                    cells: [
                        Cell([
                            .text("Temperature", style: gray),
                            .text(weather.temperature, style: right)
                        ]),
                        Cell([
                            .text("Wind", style: gray),
                            .text(weather.wind, style: right)
                        ]),
                        Cell([
                            .text("Description", style: gray),
                            .text(weather.description, style: right)
                        ]),
                    ]
                ),
                Section(header: Cell(.text("Forecast", style: center)), cells: [
                    Cell(weather.forecast.map({ day in
                        Atom.text("Day " + day.day, style: centerGray)
                    })),
                    Cell(weather.forecast.map({ day in
                        Atom.text(day.temperature, style: center)
                    })),
                    Cell(weather.forecast.map({ day in
                        Atom.text(day.wind, style: center)
                    })),
                ])]
            )
        }
    }
    
    static func citiesClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                  let store = app?.store
            else { return nil }
            
            let cities = [
                "Amsterdam",
                "London",
                "Madrid",
                "New York",
                "Paris",
                "San Francisco",
            ]
            
            return ViewModel(style: cache.modelStyle, title: "Cities", sections: [
                Section(
                    header: Cell(.text("Choose a city", style: nil)),
                    cells: cities.sorted(by: { $0 < $1 }).map({ city in
                        Cell(
                            .text(city,
                                style: nil,
                                onTap: {
                                    store.set(.weatherCity, value: city)
                                }
                            )
                        )
                    })
                )]
            )
        }
    }
}
