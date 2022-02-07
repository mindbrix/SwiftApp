//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

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
        stack.constrainToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func applyCell(_ cell: Cell) {
        switch cell {
        case .button(let title, _):
            backgroundColor = .red
            label0.textAlignment = .center
            label0.text = title
        case .standard(let title, let body, _):
            backgroundColor = .white
            label0.textAlignment = .left
            label0.text = title
            label1.textAlignment = .left
            label1.text = body
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
