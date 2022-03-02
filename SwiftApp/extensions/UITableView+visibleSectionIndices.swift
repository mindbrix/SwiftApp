//
//  UITableView+visibleSectionIndices.swift
//  SwiftApp
//
//  Created by Nigel Barber on 02/03/2022.
//

import UIKit

extension UITableView {
    func visibleSectionIndices(count: Int) -> [Int] {
        let visible = CGRect(
            origin: contentOffset,
            size: bounds.size)
    
        return Array(0 ..< count).filter({ i in
            let rect = style == .plain ? rect(forSection: i) : rectForHeader(inSection: i)
            return visible.intersects(rect)
        })
    }
}
