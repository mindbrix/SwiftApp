//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

class CellView: UIView {
    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
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
        addSubview(stack)
        stack.constrainToSuperview(insets: Self.defaultStackInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cell: Cell? {
        didSet {
            applyCell(cell)
        }
    }
    
    private func applyCell(_ cell: Cell?) {
        for subview in stack.subviews {
            subview.removeFromSuperview()
        }
        guard let cell = cell else { return }
        
        stack.addArrangedSubview(label0)
        switch cell {
        case .button(let title, _):
            backgroundColor = .red
            label0.textAlignment = .center
            label0.text = title
        case .standard(let title, let body, _):
            backgroundColor = .white
            label0.textAlignment = .left
            label0.text = title
            stack.addArrangedSubview(label1)
            label1.textAlignment = .left
            label1.text = body
        }
    }
}
