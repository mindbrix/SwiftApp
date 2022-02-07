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

class CellView: UIView {
    lazy var label0: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var label1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.addArrangedSubview(label0)
        stack.addArrangedSubview(label1)
        addSubview(stack)
        stack.constrainToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TableViewCell: UITableViewCell {
    lazy var cellView: CellView = {
        let cellView = CellView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellView)
        cellView.constrainToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
