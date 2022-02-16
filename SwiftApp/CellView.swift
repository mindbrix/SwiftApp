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
                    return ImageView.description()
                        + (width != nil ? ".width" : "")
                        + (onTap != nil ? ".onTap" : "")
                case .input( _, _, _, let onSet, _):
                    return TextField.description()
                        + (onSet != nil ? ".onSet" : "")
                case .text( _, _, let onTap):
                    return UILabel.description()
                        + (onTap != nil ? ".onTap" : "")
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
        NSLayoutConstraint.activate(
            insetConstraints
            + [heightAnchor.constraint(greaterThanOrEqualToConstant: 1)]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(_ cell: Cell?, modelStyle: Style,responderClosure: ResponderClosure? = nil) {
        self.cell = cell
        stackInsets = .zero
        stack.axis = .vertical
        stack.spacing = Self.spacing
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            emptyStack()
            setupStack(responderClosure: responderClosure)
        }
        backgroundColor = .white
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let style):
            let cellStyle = style ?? modelStyle.cell
            let defaultInsets = UIEdgeInsets(
                top: Self.spacing,
                left: Self.spacing,
                bottom: Self.spacing,
                right: Self.spacing)
            stackInsets = cellStyle.insets ?? defaultInsets
            stack.axis = cellStyle.isVertical ? .vertical : .horizontal
            for (index, atom) in atoms.enumerated() {
                applyAtom(atom,
                    modelStyle: modelStyle,
                    view: stack.subviews[index])
            }
            backgroundColor = cellStyle.color
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
    
    private func emptyStack() {
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
    }
    private func setupStack(responderClosure: ResponderClosure? = nil) {
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _):
            for atom in atoms {
               switch atom {
               case .image(_, let width, let onTap):
                    let iv = ImageView()
                    if onTap != nil {
                        iv.addGestureRecognizer(UITapGestureRecognizer(
                            target: self,
                            action: #selector(onTapper)))
                        iv.isUserInteractionEnabled = true
                    }
                    iv.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(iv)
                    stack.alignment = width != nil ? .leading : .fill
                case .input(_, _, _, _, let onSet):
                    let tf = TextField()
                    tf.isUserInteractionEnabled = onSet != nil
                    tf.responderClosure = responderClosure
                    tf.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(tf)
                case .text(_, _, let onTap):
                    let lb = UILabel()
                    lb.numberOfLines = 0
                    if onTap != nil {
                        lb.addGestureRecognizer(UITapGestureRecognizer(
                            target: self,
                            action: #selector(onTapper)))
                        lb.isUserInteractionEnabled = true
                    }
                    lb.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(lb)
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
            guard let tf = view as? TextField else { return }
            let textStyle = style ?? modelStyle.text
            tf.onSet = onSet
            tf.text = value
            tf.placeholder = placeholder
            tf.font = textStyle.font
            tf.textAlignment = textStyle.alignment
            tf.textColor = textStyle.color
            tf.clearButtonMode = .whileEditing
            tf.autocapitalizationType = .none
            tf.isSecureTextEntry = isSecure
            underline.backgroundColor = onSet == nil ? .lightGray : .clear
            tf.underline.backgroundColor = onSet == nil ? .clear : .lightGray
        case .text(let string, let style, let onTap):
            guard let lb = view as? UILabel else { return }
            let textStyle = style ?? modelStyle.text
            lb.text = string
            lb.font = textStyle.font
            lb.textAlignment = textStyle.alignment
            lb.textColor = onTap == nil ? textStyle.color : .blue
        }
    }
    
    @objc func onTapper(_ sender: UITapGestureRecognizer) {
        guard let cell = cell, let view = sender.view,
                let index = stack.subviews.firstIndex(of: view) else { return }
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
