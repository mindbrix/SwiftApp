//
//  TableViewCell.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    lazy var cellView: CellView = {
        let cellView = CellView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellView)
        cellView.constrainToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
