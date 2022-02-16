//
//  TableViewCell.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import UIKit

class CellViewCell: UITableViewCell {
    static let reuseID = String(describing: CellViewCell.self)
    
    let cellView = CellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellView)
        NSLayoutConstraint.activate(cellView.insetConstraintsFrom(self.contentView))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
