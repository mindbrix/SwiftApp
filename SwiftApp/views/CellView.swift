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
            + [heightAnchor.constraint(greaterThanOrEqualToConstant: 1 / contentScaleFactor)]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyCell(_ cell: Cell?, modelStyle: ModelStyle, fadeColor: UIColor? = .red) -> Bool {
        self.cell = cell
        stack.axis = .horizontal
        stack.layoutMargins = .zero
        stack.spacing = 0
        
        let types = cell?.atomsTypes ?? []
        if types != atomsTypes {
            atomsTypes = types
            emptyStack()
            setupStack()
        }
        backgroundColor = modelStyle.cell.color
        underline.isHidden = true
        
        guard let cell = cell
        else {
            let willResize = cellHash != 0
            cellHash = 0
            return willResize
        }
        
        let cellStyle = cell.style ?? modelStyle.cell
        let stackStyle = cellStyle.stackStyle
        stack.axis = stackStyle.axis
        stack.alignment = stackStyle.alignment ?? (stackStyle.axis == .vertical ? .fill : .center)
        stack.distribution = stackStyle.distribution ?? .fill
        stack.layoutMargins = stackStyle.insets ?? .zero
        stack.spacing = stackStyle.spacing ?? 0
        
        if let color = cellStyle.underline {
            underline.backgroundColor = color
            underline.isHidden = false
        }
        backgroundColor = cellStyle.color
        
        var willResize = false
        
        let cellStyleHash = cell.style == nil ? String(describing: modelStyle.cell).hashValue : 0
        let textStyleHash = String(describing: modelStyle.text).hashValue
        let newHash = cell.hashValue ^ cellStyleHash ^ textStyleHash
        
        if newHash != cellHash {
            cellHash = newHash
            
            for (index, atom) in cell.atoms.enumerated() {
                if let view = stack.subviews[index] as? AtomAView {
                    willResize = view.applyAtom(atom, modelStyle: modelStyle) || willResize
                }
            }
            fadeToBackground(from: fadeColor)
        }
        return willResize
    }
    
    private var cell: Cell?
    private var cellHash: Int = 0
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
