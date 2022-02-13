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
        stack.axis = .vertical
        stack.spacing = Self.spacing
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            setupStack()
        }
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let isVertical, let insets):
            stackInsets = insets ?? UIEdgeInsets(top: Self.spacing, left: Self.spacing, bottom: Self.spacing, right: Self.spacing)
            stack.axis = isVertical ? .vertical : .horizontal
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
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, _):
            for (index, atom) in atoms.enumerated() {
                guard index < 2 else { return }
                switch atom {
                case .image(_, let width, let onTap):
                    stack.alignment = width != nil ? .leading : .fill
                    stack.addArrangedSubview(image)
                    if onTap != nil {
                        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapper)))
                        image.isUserInteractionEnabled = true
                    }
                case .input(_, let set, _):
                    let field = UITextField()
                    field.delegate = self
                    field.translatesAutoresizingMaskIntoConstraints = false
                    field.isUserInteractionEnabled = set != nil
                    stack.addArrangedSubview(field)
                case .text(_, _, _, let onTap):
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(label)
                    if onTap != nil {
                        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapper)))
                        label.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    private func applyAtom(_ atom: Atom, style: FontStyle, view: UIView) {
        switch atom {
        case .image(let url, let width, _):
            guard let iv = view as? UIImageView else {  return }
            iv.image = UIImage(named: url)
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
            tf.font = UIFont(name: style.name, size: style.size * scale / 100)
            tf.textAlignment = .left
//            separator.backgroundColor = set == nil ? .lightGray : .clear
//            underline.backgroundColor = set == nil ? .clear : .lightGray
        case .text(let string, let scale, let alignment, let onTap):
            guard let label = view as? UILabel else {  return }
            label.textColor = onTap == nil ? .black : .blue
            label.text = string
            label.font = UIFont(name: style.name, size: style.size * scale / 100)
            label.textAlignment = alignment
        }
    }
    
    @objc func onTapper(_ sender: UITapGestureRecognizer) {
        guard let cell = cell, let view = sender.view, let index = stack.subviews.firstIndex(of: view) else { return }
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
        if let cell = cell, let index = stack.subviews.firstIndex(of: textField),
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
