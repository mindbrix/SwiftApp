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
    
    static let defaultWeather = Self(temperature: "--", wind: "--", description: "--", forecast: [
        Day(day: "1", temperature: "-", wind: "-"),
        Day(day: "2", temperature: "-", wind: "-"),
        Day(day: "3", temperature: "-", wind: "-")
    ])
    
    // https://github.com/robertoduessmann/weather-api
    //
    static let baseURL = "https://goweather.herokuapp.com/weather/"
    
    static func url(for city: String) -> URL? {
        guard var components = URLComponents(string: baseURL)
        else { return nil }
        
        components.path.append(contentsOf: city)
        return components.url
    }
    
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        { [weak app] in
            guard let cache = app?.styleCache,
                  let store = app?.store,
                  let network = app?.network,
                  let url = Weather.url(for: store.getString(.weatherCity)),
                  let app = app
            else { return nil }
            
            let weather = network.get(
                  Weather.self,
                  from: url
            ) ?? .defaultWeather
            
            let stackStyle = cache.modelStyle.cell.stackStyle.withAlignment(.leading)
            let cellStyle = cache.modelStyle.cell.withStackStyle(stackStyle)
            let textStyle = cache.modelStyle.text
            let gray = textStyle.withColor(.gray)
            let center = textStyle.withAlignment(.center)
            let right = textStyle.withAlignment(.right)
            let centerBlue = center.withColor(.blue)
            let centerGray = center.withColor(.gray)
            
            return ViewModel(style: cache.modelStyle, title: "Weather", sections: [
                Section(
                    header: Cell(
                        .text(store.getString(.weatherCity),
                            style: centerBlue,
                            onTap: {
                                app.present(.WeatherCities)
                            })
                    ),
                    cells: [
                        Cell([
                            .text("Temperature",
                                  style: gray),
                            .text(weather.temperature,
                                  style: right)
                            ],
                            style: cellStyle),
                        Cell([
                            .text("Wind",
                                  style: gray),
                            .text(weather.wind,
                                  style: right)
                            ],
                            style: cellStyle),
                        Cell([
                            .text("Description",
                                  style: gray),
                            .text(weather.description + weather.description + weather.description,
                                  style: right)
                            ],
                            style: cellStyle),
                    ]
                ),
                Section(
                    header: Cell(
                        .text("Forecast",
                              style: center)),
                    cells: [
                        Cell(weather.forecast.map({ day in
                            .text("Day " + day.day,
                                  style: centerGray)
                        })),
                        Cell(weather.forecast.map({ day in
                            .text(day.temperature,
                                  style: center)
                        })),
                        Cell(weather.forecast.map({ day in
                            .text(day.wind,
                                  style: center)
                        })),
                    ]
                )
            ])
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
            let textStyle = cache.modelStyle.text
            
            return ViewModel(style: cache.modelStyle, title: "Cities", sections: [
                Section(
                    header: Cell(
                        .text("Choose a city")
                    ),
                    cells: cities.sorted(by: { $0 < $1 }).map({ city in
                        Cell(
                            .text(city,
                                style: textStyle.withColor(.blue),
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
