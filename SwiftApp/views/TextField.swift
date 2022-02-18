//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

typealias ResponderClosure = (TextField) -> Bool?

class TextField : UITextField, AtomAView {
    init() {
        super.init(frame: .zero)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        NSLayoutConstraint.activate(underlineConstraints(for: underline))
        delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let underline = UIView()
    var responderClosure: ResponderClosure?
    var onSet: ((String) -> Void)?
    
    override func becomeFirstResponder() -> Bool {
       return responderClosure?(self) ?? super.becomeFirstResponder()
    }
    
    func apply(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .input(let value, let isSecure, let placeholder, let style, let onSet):
            let textStyle = style ?? modelStyle.text
            self.onSet = onSet
            text = value
            self.placeholder = placeholder
            font = textStyle.font
            textAlignment = textStyle.alignment
            textColor = textStyle.color
            clearButtonMode = .whileEditing
            autocapitalizationType = .none
            isSecureTextEntry = isSecure
            underline.backgroundColor = onSet == nil ? .clear : .lightGray
        default:
            break
        }
    }
    
    func become(_ field:  TextField) {
        topConstraint = topAnchor.constraint(equalTo: field.topAnchor)
        leadingConstraint = leadingAnchor.constraint(equalTo: field.leadingAnchor)
        trailngConstraint = trailingAnchor.constraint(equalTo: field.trailingAnchor)
        text = field.text
        placeholder = field.placeholder
        textColor = field.textColor
        textAlignment = field.textAlignment
        font = field.font
        selectedTextRange = field.selectedTextRange
        autocapitalizationType = field.autocapitalizationType
        clearButtonMode = field.clearButtonMode
        isSecureTextEntry = field.isSecureTextEntry
        underline.backgroundColor = field.underline.backgroundColor
        onSet = field.onSet
    }
    
    var topConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            topConstraint?.isActive = true
        }
    }
    var leadingConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            leadingConstraint?.isActive = true
        }
    }
    var trailngConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            trailngConstraint?.isActive = true
        }
    }
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            onSet?(text.replacingCharacters(in: textRange, with: string))
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onSet?("")
        return true
    }
}
