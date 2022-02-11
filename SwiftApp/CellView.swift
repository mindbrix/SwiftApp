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
        stack.addGestureRecognizer(tapper)
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
    
    func apply(cell: Cell?, style: FontStyle) {
        self.cell = cell
        setupStack()
        applyColors()
        applyStyle(style: style)
        applyModel()
    }
    private var cell: Cell?

    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    static let thumbSize: CGFloat = 64
    
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
    lazy var tapper: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(onTap))
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
        image.widthAnchor.constraint(equalToConstant: Self.thumbSize)
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
        stackInsets = cell == nil ? .zero : Self.defaultStackInsets
        stack.axis = .vertical
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .cell(let atoms, let isVertical):
            stack.axis = isVertical ? .vertical : .horizontal
            for (index, atom) in atoms.enumerated() {
                guard index < 2 else { return }
                switch atom {
                case .image(_, _, let onTap):
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
        case .button:
            stack.addArrangedSubview(label0)
        case .header:
            stack.addArrangedSubview(label0)
        case .image(_, _, _, let isThumbnail):
            stack.axis = isThumbnail ? .horizontal : .vertical
            stack.alignment = isThumbnail ? .leading : .fill
            stack.addArrangedSubview(image)
            stack.addArrangedSubview(label0)
        case .standard:
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(label1)
        case .textInput:
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(textField)
        }
    }
    
    private func applyColors() {
        separator.backgroundColor = .clear
        underline.backgroundColor = .clear
        label0.textColor = .black
        guard let cell = cell else { return }
        switch cell {
        case .cell(let atoms, _):
            for (index, atom) in atoms.enumerated() {
                switch atom {
                case .image:
                    break
                case .input(_, let set, _):
                    textField.textColor = set == nil ? .gray : .black
                case .text(_, _, _, let onTap):
                    labels[index].textColor = onTap == nil ? .black : .blue
                }
            }
            backgroundColor = .white
        case .button:
            label0.textColor = .blue
        case .header:
            backgroundColor = UIColor(white: 0.9, alpha: 1)
        case .image:
            backgroundColor = .white
        case .standard:
            backgroundColor = .white
        case .textInput(_, _, let set):
            backgroundColor = .white
            separator.backgroundColor = set == nil ? .lightGray : .clear
            underline.backgroundColor = set == nil ? .clear : .lightGray
        }
    }
    
    private func applyModel() {
        guard let cell = cell else { return }
        switch cell {
        case .cell(let atoms, _):
            for (index, atom) in atoms.enumerated() {
                switch atom {
                case .image(let get, _, let onTap):
                    image.image = get()
                    image.isUserInteractionEnabled = onTap != nil
                case .input(let get, let set, _):
                    textField.text = get()
                    textField.isUserInteractionEnabled = set != nil
                case .text(let string, _, _, let onTap):
                    guard index < labels.count else { return }
                    labels[index].text = string
                    labels[index].isUserInteractionEnabled = onTap != nil
                }
            }
        case .button(let title, _):
            label0.text = title
        case .header(let caption):
            label0.text = caption
        case .image(let get, let caption, _, _):
            image.image = get()
            label0.text = caption
        case .standard(let title, let caption, _):
            label0.text = title
            label1.text = caption
        case .textInput(let key, let get, let set):
            label0.text = key
            textField.text = get()
            textField.isUserInteractionEnabled = set != nil
        }
    }
    
    private func applyStyle(style: FontStyle) {
        heightConstraint?.isActive = false
        let titleFont = UIFont(name: style.name, size: style.size * 1.2)
        let captionFont = UIFont(name: style.name, size: style.size * 1.0)
        let keyFont = UIFont(name: style.name, size: style.size * 0.866)
        let valueFont = titleFont
        
        guard let cell = cell else { return }
        switch cell {
        case .cell(let atoms, _):
            for (index, atom) in atoms.enumerated() {
                switch atom {
                case .image(let get, _, _):
                    if let size = get()?.size {
                        heightConstraint = image.heightAnchor.constraint(
                            lessThanOrEqualTo: image.widthAnchor,
                            multiplier: size.height / size.width)
                        heightConstraint?.isActive = true
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
        case .button(_, _):
            label0.font = titleFont
            label0.textAlignment = .left
        case .header:
            label0.font = captionFont
            label0.textAlignment = .left
        case .image(let get, _, _, let isThumbnail):
            if let size = get()?.size {
                heightConstraint = image.heightAnchor.constraint(
                    lessThanOrEqualTo: image.widthAnchor,
                    multiplier: size.height / size.width)
                widthConstraint.isActive = isThumbnail
                heightConstraint?.isActive = true
            }
            label0.font = captionFont
            label0.textAlignment = .left
        case .standard(_, _, _):
            label0.font = titleFont
            label0.textAlignment = .left
            label1.font = captionFont
            label1.textAlignment = .left
        case .textInput(_, _, _):
            label0.font = keyFont
            label0.textAlignment = .left
            textField.font = valueFont
            textField.textAlignment = .left
        }
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let cell = cell else { return }
        switch cell {
        case .cell(let atoms, _):
            guard sender != tapper else { return }
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
        case .button(_, let onTap):
            onTap()
        case .header:
            break
        case .image(_, _, let onTap, _):
            onTap?()
        case .standard(_, _, let onTap):
            onTap?()
        case .textInput:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch cell {
        case .textInput(_, _, let set):
            if let text = textField.text, let textRange = Range(range, in: text) {
                set?(text.replacingCharacters(in: textRange, with: string))
            }
        default:
            break
        }
        return true
    }
}
