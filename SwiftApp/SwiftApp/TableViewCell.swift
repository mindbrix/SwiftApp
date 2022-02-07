//
//  TableViewCell.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import UIKit

extension UIView {
    func constrainToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

class TableViewCell: UITableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        label.constrainToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
