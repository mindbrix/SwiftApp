//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

extension Cell {
    var atomsTypes: [String] {
        switch self {
        case .stack(let atoms, _, _):
            return atoms.map( { atom in
                switch atom{
                case .image:
                    return UIImageView.description()
                case .input:
                    return UITextField.description()
                case .text:
                    return UILabel.description()
                }
            })
        }
    }
}

class CellView: UIView, UITextFieldDelegate {
    init() {
        super.init(frame: .zero)
        addSubview(stack)
        addSubview(separator)
        NSLayoutConstraint.activate([
            insetConstraints.top, insetConstraints.left, insetConstraints.bottom, insetConstraints.right,
            heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(cell: Cell?, style: FontStyle, isHeader: Bool = false) {
        self.cell = cell
        stackInsets = .zero
        setupStack()
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, let insets):
            stackInsets = insets ?? UIEdgeInsets(top: CellView.spacing, left: CellView.spacing, bottom: CellView.spacing, right: CellView.spacing)
            for (index, atom) in atoms.enumerated() {
                applyAtom(atom, style: style, view: stack.subviews[index])
            }
        }
        backgroundColor = isHeader ? UIColor(white: 0.9, alpha: 1) : .white
    }
    private var cell: Cell?
    private var atomsTypes: [String] = []
    
    static let spacing: CGFloat = 4
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    lazy var label0: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
    lazy var labels: [UILabel] = {
        [label0, label1]
    }()
    lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var tappers: [UITapGestureRecognizer] = {
        [UITapGestureRecognizer(target: self, action: #selector(onTap)),
         UITapGestureRecognizer(target: self, action: #selector(onTap))]
    }()
    lazy var textField: UITextField = {
        let field = UITextField()
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addSubview(underline)
        NSLayoutConstraint.activate([
            underline.leadingAnchor.constraint(equalTo: field.leadingAnchor),
            underline.widthAnchor.constraint(equalTo: field.widthAnchor, multiplier: 0.9),
            underline.bottomAnchor.constraint(equalTo: field.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return field
    }()
    lazy var underline: UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
    }()
    lazy var widthConstraint: NSLayoutConstraint = {
        image.widthAnchor.constraint(equalToConstant: 0)
    }()
    var heightConstraint: NSLayoutConstraint?
    
    lazy var insetConstraints: ConstraintQuadtuple = {
        stack.constraintsToView(self)
    }()
    var stackInsets: UIEdgeInsets = .zero {
        didSet {
            insetConstraints.top.constant = stackInsets.top
            insetConstraints.left.constant = stackInsets.left
            insetConstraints.bottom.constant = -stackInsets.bottom
            insetConstraints.right.constant = -stackInsets.right
        }
    }
    
    private func setupStack() {
        let types = cell?.atomsTypes ?? []
        guard types != atomsTypes else { return }
        atomsTypes = types
        
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Self.spacing
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let isVertical, _):
            stack.axis = isVertical ? .vertical : .horizontal
            for (index, atom) in atoms.enumerated() {
                guard index < 2 else { return }
                switch atom {
                case .image(_, let width, let onTap):
                    stack.alignment = width != nil ? .leading : .fill
                    stack.addArrangedSubview(image)
                    if onTap != nil {
                        image.addGestureRecognizer(tappers[index])
                    }
                case .input:
                    stack.addArrangedSubview(textField)
                case .text(_, _, _, let onTap):
                    stack.addArrangedSubview(labels[index])
                    if onTap != nil {
                        labels[index].addGestureRecognizer(tappers[index])
                    }
                }
            }
        }
    }
    
    private func applyAtom(_ atom: Atom, style: FontStyle, view: UIView) {
        switch atom {
        case .image(let url, let width, let onTap):
            guard let iv = view as? UIImageView else {  return }
            iv.image = UIImage(named: url)
            iv.isUserInteractionEnabled = onTap != nil
            if let size = UIImage(named: url)?.size {
                heightConstraint = image.heightAnchor.constraint(
                    lessThanOrEqualTo: image.widthAnchor,
                    multiplier: size.height / size.width)
                heightConstraint?.isActive = true
                widthConstraint.constant = width ?? 0
                widthConstraint.isActive = width != nil
            }
        case .input(let get, let set, let scale):
            guard let tf = view as? UITextField else {  return }
            tf.textColor = set == nil ? .gray : .black
            tf.text = get()
            tf.isUserInteractionEnabled = set != nil
            tf.font = UIFont(name: style.name, size: style.size * scale / 100)
            tf.textAlignment = .left
//            separator.backgroundColor = set == nil ? .lightGray : .clear
//            underline.backgroundColor = set == nil ? .clear : .lightGray
        case .text(let string, let scale, let alignment, let onTap):
            guard let label = view as? UILabel else {  return }
            label.textColor = onTap == nil ? .black : .blue
            label.text = string
            label.isUserInteractionEnabled = onTap != nil
            label.font = UIFont(name: style.name, size: style.size * scale / 100)
            label.textAlignment = alignment
        }
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let cell = cell, let view = sender.view, let index = stack.subviews.firstIndex(of: view), index < 2 else { return }
        switch cell {
        case .stack(let atoms, _, _):
            switch atoms[index] {
            case .image(_ , _, let onTap):
                onTap?()
            case .input:
                break
            case .text(_, _, _, let onTap):
                onTap?()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let cell = cell else { return false }
        if let index = stack.subviews.firstIndex(of: textField), index < 2,
           let text = textField.text, let textRange = Range(range, in: text) {
            switch cell {
            case .stack(let atoms, _, _):
                switch atoms[index] {
                case .input(_, let set, _):
                    set?(text.replacingCharacters(in: textRange, with: string))
                default:
                    break
                }
            }
        }
        return true
    }
}
