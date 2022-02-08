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
    
    convenience init(cell: Cell) {
        self.init(frame: .zero)
        self.cell = cell
        applyCell()
    }
    
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
            applyCell()
        }
    }
    
    private func applyCell() {
        for subview in stack.subviews {
            subview.removeFromSuperview()
        }
        guard let cell = cell else { return }
        
        stack.addArrangedSubview(label0)
        switch cell {
        case .button(let title, _):
            label0.text = title
            label0.textAlignment = .center
            backgroundColor = .red
        case .standard(let title, let body, _):
            label0.text = title
            label0.textAlignment = .left
            stack.addArrangedSubview(label1)
            label1.text = body
            label1.textAlignment = .left
            backgroundColor = .white
        }
    }
}
