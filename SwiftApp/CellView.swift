//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

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
        setupStack()
        applyColors(isHeader: isHeader)
        applyStyle(style: style)
        applyModel()
    }
    private var cell: Cell?

    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
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
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
        stackInsets = .zero
        stack.axis = .vertical
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let isVertical, let inset):
            stackInsets = inset ?? Self.defaultStackInsets
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
    
    private func applyColors(isHeader: Bool) {
        separator.backgroundColor = .clear
        underline.backgroundColor = .clear
        label0.textColor = .black
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, _):
            for (index, atom) in atoms.enumerated() {
                switch atom {
                case .image:
                    break
                case .input(_, let set, _):
                    textField.textColor = set == nil ? .gray : .black
                    separator.backgroundColor = set == nil ? .lightGray : .clear
                    underline.backgroundColor = set == nil ? .clear : .lightGray
                case .text(_, _, _, let onTap):
                    labels[index].textColor = onTap == nil ? .black : .blue
                }
            }
            backgroundColor = isHeader ? UIColor(white: 0.9, alpha: 1) : .white
        }
    }
    
    private func applyModel() {
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, _):
            for (index, atom) in atoms.enumerated() {
                guard index < labels.count else { return }
                switch atom {
                case .image(let get, _, let onTap):
                    image.image = get()
                    image.isUserInteractionEnabled = onTap != nil
                case .input(let get, let set, _):
                    textField.text = get()
                    textField.isUserInteractionEnabled = set != nil
                case .text(let string, _, _, let onTap):
                    labels[index].text = string
                    labels[index].isUserInteractionEnabled = onTap != nil
                }
            }
        }
    }
    
    private func applyStyle(style: FontStyle) {
        heightConstraint?.isActive = false
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, _):
            for (index, atom) in atoms.enumerated() {
                switch atom {
                case .image(let get, let width, _):
                    if let size = get()?.size {
                        heightConstraint = image.heightAnchor.constraint(
                            lessThanOrEqualTo: image.widthAnchor,
                            multiplier: size.height / size.width)
                        heightConstraint?.isActive = true
                        widthConstraint.constant = width ?? 0
                        widthConstraint.isActive = width != nil
                    }
                case .input(_, _, let scale):
                    textField.font = UIFont(name: style.name, size: style.size * scale / 100)
                    textField.textAlignment = .left
                case .text(_, let scale, let alignment, _):
                    guard index < labels.count else { return }
                    labels[index].font = UIFont(name: style.name, size: style.size * scale / 100)
                    labels[index].textAlignment = alignment
                }
            }
        }
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _, _):
            if let index = tappers.firstIndex(of: sender), index < 2 {
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
