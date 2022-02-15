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
                case .image(_, let width, let onTap):
                    return ImageView.description() + (width != nil ? ".width" : "") + (onTap != nil ? ".onTap" : "")
                case .input(_, let onSet, _):
                    return TextField.description() + (onSet != nil ? ".onSet" : "")
                case .text( _, _, let onTap):
                    return UILabel.description() + (onTap != nil ? ".onTap" : "")
                }
            })
        }
    }
}

class CellView: UIView, UITextFieldDelegate {
    init() {
        super.init(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        NSLayoutConstraint.activate(insetConstraints + [
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
    
    func apply(cell: Cell?, style: FontStyle, isHeader: Bool = false, responderClosure: ResponderClosure? = nil) {
        self.cell = cell
        stackInsets = .zero
        stack.axis = .vertical
        stack.spacing = Self.spacing
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            setupStack(responderClosure: responderClosure)
        }
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let isVertical, let insets):
            stackInsets = insets ?? UIEdgeInsets(top: Self.spacing, left: Self.spacing, bottom: Self.spacing, right: Self.spacing)
            stack.axis = isVertical ? .vertical : .horizontal
            for (index, atom) in atoms.enumerated() {
                applyAtom(atom, fontStyle: style, view: stack.subviews[index])
            }
        }
        backgroundColor = isHeader ? UIColor(white: 0.9, alpha: 1) : .white
    }
    private var cell: Cell?
    private var atomsTypes: [String] = []
    let separator = UIView()
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
                case .input(_, _, let onSet):
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
    
    private func applyAtom(_ atom: Atom, fontStyle: FontStyle, view: UIView) {
        switch atom {
        case .image(let url, let width, _):
            guard let image = view as? ImageView else { return }
            image.setAspectImage(UIImage(named: url), width: width)
        case .input(let value, let style, let onSet):
            guard let field = view as? TextField else { return }
            let textStyle = style ?? .init()
            field.onSet = onSet
            field.text = value
            field.font = UIFont(name: fontStyle.name, size: fontStyle.size * textStyle.scale / 100)
            field.textAlignment = textStyle.alignment
            field.textColor = onSet == nil ? .gray : .black
            separator.backgroundColor = onSet == nil ? .lightGray : .clear
            field.underline.backgroundColor = onSet == nil ? .clear : .lightGray
        case .text(let string, let style, let onTap):
            guard let label = view as? UILabel else { return }
            let textStyle = style ?? .init()
            label.text = string
            label.font = UIFont(name: fontStyle.name, size: fontStyle.size * textStyle.scale / 100)
            label.textAlignment = textStyle.alignment
            label.textColor = onTap == nil ? .black : .blue
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
            case .text(_, _, let onTap):
                onTap?()
            }
        }
    }
}
