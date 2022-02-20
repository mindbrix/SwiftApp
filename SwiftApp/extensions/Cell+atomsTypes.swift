//
//  Cell+atomsTypes.swift
//  SwiftApp
//
//  Created by Nigel Barber on 18/02/2022.
//

import Foundation

extension Cell {
    var atomsTypes: [String] {
        return [axis == .horizontal ? "horizontal." : "vertical."]
            + atoms.map( { atom in
                switch atom{
                case .image(_, _, let onTap):
                    return ImageView.description()
                        + (onTap != nil ? ".onTap" : "")
                case .input( _, _, _, let onSet, _):
                    return TextField.description()
                        + (onSet != nil ? ".onSet" : "")
                case .text( _, _, let onTap):
                    return Label.description()
                        + (onTap != nil ? ".onTap" : "")
                }
            })
    }
}
