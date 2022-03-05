//
//  MainScreen.swift
//  SwiftApp
//
//  Created by Nigel Barber on 05/03/2022.
//

import Foundation
import UIKit


struct MainScreen {
    static func mainClosure(app: SwiftApp) -> ViewModel.Closure {
        let grab0 = UIImage(named: "grab0") ?? UIImage()
        
        return { [weak app] in
            guard let cache = app?.styleCache,
                    let network = app?.network,
                    let app = app
            else { return nil }
            
            let cellStyle = cache.modelStyle.cell
            let imageURL = URL(string: "https://frame.ai/images/tour-early-warning@2x.png")
            let image = network.getImage(imageURL)
    
            return ViewModel(style: cache.modelStyle, title: "Main", sections: [
                Section(
                    header: Cell(.text("Menu")),
                    cells: Screen.allCases.filter({ !$0.embedInNavController }).map({ menuScreen in
                        Cell(.text(menuScreen.rawValue,
                                   style: cache.modelStyle.text.withColor(.blue),
                                onTap: {
                                    app.push(menuScreen)
                                }
                            )
                        )
                    })
                ),
                Section(
                    header: Cell(.text("Images")),
                    cells: [
                        Cell([
                            .image(image ?? grab0,
                                onTap: {
                                    print("grab0")
                                }
                            ),
                            .text(.longText,
                                style: cache.smallStyle
                            )],
                            style: cellStyle.withStackStyle(cellStyle.stackStyle.withAxis(.vertical))
                        ),
                        Cell([
                            .image(grab0,
                                style: cache.modelStyle.image.withWidth(64),
                                onTap: {
                                    print("grab0")
                                }
                            ),
                            .text(.longText,
                                style: cache.smallStyle
                            ),
                        ]),
                    ])
            ])
        }
    }
}
