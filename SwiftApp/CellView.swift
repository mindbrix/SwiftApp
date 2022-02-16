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
        case .stack(let atoms, _):
            return atoms.map( { atom in
                switch atom{
                case .image(_, let width, let onTap):
                    return ImageView.description() + (width != nil ? ".width" : "") + (onTap != nil ? ".onTap" : "")
                case .input( _, _, _, let onSet, _):
                    return TextField.description() + (onSet != nil ? ".onSet" : "")
                case .text( _, _, let onTap):
                    return UILabel.description() + (onTap != nil ? ".onTap" : "")
                }
            })
        }
    }
}

class CellView: UIView {
    init() {
        super.init(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        addUnderlineConstraints(underline)
        NSLayoutConstraint.activate(insetConstraints + [heightAnchor.constraint(greaterThanOrEqualToConstant: 1)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(cell: Cell?, modelStyle: Style,responderClosure: ResponderClosure? = nil) {
        self.cell = cell
        stackInsets = .zero
        stack.axis = .vertical
        stack.spacing = Self.spacing
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            setupStack(responderClosure: responderClosure)
        }
        backgroundColor = .white
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let style):
            backgroundColor = style?.color ?? modelStyle.cell.color
            stackInsets = style?.insets
                ?? modelStyle.cell.insets
                ?? UIEdgeInsets(top: Self.spacing, left: Self.spacing, bottom: Self.spacing, right: Self.spacing)
            stack.axis = (style?.isVertical ?? false) ? .vertical : .horizontal
            for (index, atom) in atoms.enumerated() {
                applyAtom(atom, modelStyle: modelStyle, view: stack.subviews[index])
            }
        }
    }
    private var cell: Cell?
    private var atomsTypes: [String] = []
    let underline = UIView()
    let stack = UIStackView()
    static let spacing: CGFloat = 4
    
    lazy var insetConstraints: [NSLayoutConstraint] = {
        stack.insetConstraintsFrom(self)
    }()
    var stackInsets: UIEdgeInsets = .zero {
        didSet {
            insetConstraints[0].constant = stackInsets.top
            insetConstraints[1].constant = stackInsets.left
            insetConstraints[2].constant = -stackInsets.bottom
            insetConstraints[3].constant = -stackInsets.right
        }
    }
    
    private func setupStack(responderClosure: ResponderClosure? = nil) {
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _):
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
                case .input(_, _, _, _, let onSet):
                    let field = TextField()
                    field.translatesAutoresizingMaskIntoConstraints = false
                    field.isUserInteractionEnabled = onSet != nil
                    field.responderClosure = responderClosure
                    stack.addArrangedSubview(field)
                case .text(_, _, let onTap):
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
    
    private func applyAtom(_ atom: Atom, modelStyle: Style, view: UIView) {
        switch atom {
        case .image(let image, let width, _):
            guard let iv = view as? ImageView else { return }
            iv.setAspectImage(image, width: width)
        case .input(let value, let isSecure, let placeholder, let style, let onSet):
            guard let field = view as? TextField else { return }
            let textStyle = style ?? modelStyle.text
            field.onSet = onSet
            field.text = value
            field.placeholder = placeholder
            field.font = textStyle.font
            field.textAlignment = textStyle.alignment
            field.textColor = textStyle.color
            field.clearButtonMode = .whileEditing
            field.autocapitalizationType = .none
            field.isSecureTextEntry = isSecure
            underline.backgroundColor = onSet == nil ? .lightGray : .clear
            field.underline.backgroundColor = onSet == nil ? .clear : .lightGray
        case .text(let string, let style, let onTap):
            guard let label = view as? UILabel else { return }
            let textStyle = style ?? modelStyle.text
            label.text = string
            label.font = textStyle.font
            label.textAlignment = textStyle.alignment
            label.textColor = onTap == nil ? textStyle.color : .blue
        }
    }
    
    @objc func onTapper(_ sender: UITapGestureRecognizer) {
        guard let cell = cell, let view = sender.view, let index = stack.subviews.firstIndex(of: view) else { return }
        switch cell {
        case .stack(let atoms, _):
            switch atoms[index] {
            case .image(_ , _, let onTap):
                onTap?()
            case .input:
                break
            case .text(_, _, let onTap):
                onTap?()
            }
        }
    }
}
