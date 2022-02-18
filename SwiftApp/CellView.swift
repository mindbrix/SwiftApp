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
                    return Label.description()
                        + (onTap != nil ? ".onTap" : "")
                }
            })
        }
    }
}

protocol AtomAView {
    func apply(_ atom: Atom, modelStyle: ModelStyle)
}

class CellView: UIView {
    init() {
        super.init(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        NSLayoutConstraint.activate(
            underlineConstraints(for: underline)
            + insetConstraints
            + [heightAnchor.constraint(greaterThanOrEqualToConstant: 1)]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(_ cell: Cell?, modelStyle: ModelStyle, responderClosure: ResponderClosure? = nil) {
        self.cell = cell
        stackInsets = .zero
        stack.axis = .vertical
        stack.spacing = ModelStyle.spacing
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            emptyStack()
            setupStack(responderClosure: responderClosure)
        }
        backgroundColor = modelStyle.cell.color
        underline.backgroundColor = .lightGray
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, let style):
            let cellStyle = style ?? modelStyle.cell
            stackInsets = cellStyle.insets ?? ModelStyle.defaultInsets
            stack.axis = cellStyle.isVertical ? .vertical : .horizontal
            stack.alignment = cellStyle.isVertical ? .fill : .center
            for (index, atom) in atoms.enumerated() {
                (stack.subviews[index] as? AtomAView)?.apply(atom, modelStyle: modelStyle)
            }
            backgroundColor = cellStyle.color
        }
    }
    private var cell: Cell?
    private var atomsTypes: [String] = []
    private let underline = UIView()
    private let stack = UIStackView()
    
    lazy var insetConstraints: [NSLayoutConstraint] = {
        edgeConstraints(for: stack)
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
        guard let cell = cell else { return }
        switch cell {
        case .stack(let atoms, _):
            for atom in atoms {
               switch atom {
               case .image(_, _, let onTap):
                    let iv = ImageView()
                    if onTap != nil {
                        iv.addGestureRecognizer(UITapGestureRecognizer(
                            target: self,
                            action: #selector(onTapper)))
                        iv.isUserInteractionEnabled = true
                    }
                    iv.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(iv)
                case .input(_, _, _, _, let onSet):
                    let tf = TextField()
                    tf.isUserInteractionEnabled = onSet != nil
                    tf.responderClosure = responderClosure
                    tf.translatesAutoresizingMaskIntoConstraints = false
                    stack.addArrangedSubview(tf)
                case .text(_, _, let onTap):
                    let lb = Label()
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
