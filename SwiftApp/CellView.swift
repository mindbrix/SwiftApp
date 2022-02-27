//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit


class CellView: UIView {
    init() {
        super.init(frame: .zero)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        NSLayoutConstraint.activate(
            edgeConstraints(for: stack)
            + underlineConstraints(for: underline)
            + [heightAnchor.constraint(greaterThanOrEqualToConstant: 1)]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyCell(_ cell: Cell?, modelStyle: ModelStyle, fadeColor: UIColor = .red) {
        let oldHash = self.cell?.hashValue ?? 0
        
        self.cell = cell
        stack.directionalLayoutMargins = .zero
        stack.axis = .horizontal
        stack.spacing = modelStyle.cell.spacing ?? 0
        
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            emptyStack()
            setupStack()
        }
        backgroundColor = modelStyle.cell.color
        underline.isHidden = true
        
        guard let cell = cell
        else { return }
        
        let cellStyle = cell.style ?? modelStyle.cell
        let insets = cellStyle.insets ?? .zero
        stack.directionalLayoutMargins = insets.directionalInsets
        stack.axis = cell.axis == .horizontal ? .horizontal : .vertical
        stack.alignment = cell.axis == .vertical ? .fill : .center
        stack.spacing = cellStyle.spacing ?? 0
        
        if let color = cellStyle.underline {
            underline.backgroundColor = color
            underline.isHidden = false
        }
        backgroundColor = cellStyle.color
        
        if oldHash != cell.hashValue {
            for (index, atom) in cell.atoms.enumerated() {
                (stack.subviews[index] as? AtomAView)?.applyAtom(atom, modelStyle: modelStyle)
            }
            fadeToBackground(from: fadeColor)
        }
    }
    
    private var cell: Cell?
    private var atomsTypes: [String] = []
    private let underline = UIView()
    private let stack = UIStackView()
    
    private func emptyStack() {
        for subview in stack.subviews {
            subview.removeFromSuperview()
            for recognizer in subview.gestureRecognizers ?? [] {
                subview.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    private func setupStack() {
        guard let cell = cell
        else { return }
        
        for atom in cell.atoms {
           switch atom {
           case .image(_, _, let onTap):
                let iv = ImageView()
                if onTap != nil {
                    iv.addGestureRecognizer(
                        UITapGestureRecognizer(
                            target: self,
                            action: #selector(onAtomTap))
                    )
                    iv.isUserInteractionEnabled = true
                }
                iv.translatesAutoresizingMaskIntoConstraints = false
                stack.addArrangedSubview(iv)
            case .input(_, _, _, _, let onSet):
                let tf = TextField()
                tf.isUserInteractionEnabled = onSet != nil
                tf.translatesAutoresizingMaskIntoConstraints = false
                stack.addArrangedSubview(tf)
            case .text(_, _, let onTap):
                let lb = Label()
                lb.numberOfLines = 0
                if onTap != nil {
                    lb.addGestureRecognizer(
                        UITapGestureRecognizer(
                            target: self,
                            action: #selector(onAtomTap))
                    )
                    lb.isUserInteractionEnabled = true
                }
                lb.translatesAutoresizingMaskIntoConstraints = false
                stack.addArrangedSubview(lb)
            }
        }
    }
    
    @objc func onAtomTap(_ sender: UITapGestureRecognizer) {
        guard let cell = cell,
                let view = sender.view,
                let index = stack.subviews.firstIndex(of: view),
                index < cell.atoms.count
        else { return }
        
        switch cell.atoms[index] {
        case .image(_ , _, let onTap):
            onTap?()
        case .input:
            break
        case .text(_, _, let onTap):
            onTap?()
        }
    }
}
