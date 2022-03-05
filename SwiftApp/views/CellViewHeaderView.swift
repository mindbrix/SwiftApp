//
//  CellViewHeaderView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 24/02/2022.
//

import Foundation
import UIKit

class CellViewHeaderView: UITableViewHeaderFooterView {
    static let reuseID = String(describing: CellViewHeaderView.self)
    
    let cellView = CellView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellView)
        NSLayoutConstraint.activate(
            self.contentView.edgeConstraints(for: cellView)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
