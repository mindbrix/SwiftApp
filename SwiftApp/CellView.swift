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
                case .image(_, _, let onTap):
                    return ImageView.description() + (onTap != nil ? ".onTap" : "")
                case .input:
                    return TextField.description()
                case .text(_, _, _, let onTap):
                    return UILabel.description() + (onTap != nil ? ".onTap" : "")
                }
            })
        }
    }
}

class ImageView: UIImageView {
    func setAspectImage(_ image: UIImage?, width: CGFloat? = nil) {
        self.image = image
        heightConstraint = nil
        if let size = image?.size {
            heightConstraint = heightAnchor.constraint(
                lessThanOrEqualTo: widthAnchor,
                multiplier: size.height / size.width)
            heightConstraint?.isActive = true
        }
        widthConstraint.constant = width ?? 0
        widthConstraint.isActive = width != nil
    }
    var heightConstraint: NSLayoutConstraint?
    lazy var widthConstraint: NSLayoutConstraint = {
        widthAnchor.constraint(equalToConstant: 0)
    }()
}

class TextField : UITextField {
    init() {
        super.init(frame: .zero)
        addSubview(underline)
        NSLayoutConstraint.activate([
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var canResign = true
    override var canResignFirstResponder: Bool {
        canResign
    }
    lazy var underline: UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
    }()
}

class CellView: UIView, UITextFieldDelegate {
    init() {
        super.init(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        separator.translatesAutoresizingMaskIntoConstraints = false
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
    let separator = UIView()
    let stack = UIStackView()
    static let spacing: CGFloat = 4
    
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
            for (_, atom) in atoms.enumerated() {
               switch atom {
                case .image(_, let width, let onTap):
                    stack.alignment = width != nil ? .leading : .fill
                    let image = ImageView()
                    image.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(image)
                    if onTap != nil {
                        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapper)))
                        image.isUserInteractionEnabled = true
                    }
                case .input(_, let set, _):
                    let field = TextField()
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
            guard let image = view as? ImageView else { return }
            image.setAspectImage(UIImage(named: url), width: width)
        case .input(let get, let set, let scale):
            guard let field = view as? TextField else { return }
            field.textColor = set == nil ? .gray : .black
            field.text = get()
            field.font = UIFont(name: style.name, size: style.size * scale / 100)
            field.textAlignment = .left
            separator.backgroundColor = set == nil ? .lightGray : .clear
            field.underline.backgroundColor = set == nil ? .clear : .lightGray
        case .text(let string, let scale, let alignment, let onTap):
            guard let label = view as? UILabel else { return }
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
