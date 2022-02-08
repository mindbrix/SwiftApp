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
    lazy var tapper: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(onTap))
    }()
    
    convenience init(cell: Cell) {
        self.init(frame: .zero)
        self.cell = cell
        applyCell()
        applyCellStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        stack.constrainToSuperview(insets: Self.defaultStackInsets)
        stack.addGestureRecognizer(tapper)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cell: Cell? {
        didSet {
            applyCell()
            applyCellStyle()
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
        case .header(let title):
            label0.text = title
        case .standard(let title, let body, _):
            label0.text = title
            stack.addArrangedSubview(label1)
            label1.text = body
        }
    }
    
    private func applyCellStyle() {
        guard let cell = cell else { return }
        
        let fontSize: CGFloat = 14
        switch cell {
        case .button(_, _):
            label0.textAlignment = .center
            label0.font = UIFont.systemFont(ofSize: fontSize * 1.33, weight: .medium)
            backgroundColor = .red
        case .header( _):
            label0.textAlignment = .left
            label0.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            backgroundColor = UIColor(white: 0.9, alpha: 1)
        case .standard(_, _, _):
            label0.textAlignment = .left
            label0.font = UIFont.systemFont(ofSize: fontSize * 1.2, weight: .regular)
            label1.textAlignment = .left
            label1.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            backgroundColor = .white
        }
    }
    
    @objc func onTap() {
        guard let cell = cell else { return }
        
        switch cell {
        case .button(_, let onTap):
            onTap()
        case .header( _):
            break
        case .standard(_, _, let onTap):
            onTap?()
        }
    }
}
