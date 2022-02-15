//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

typealias ResponderClosure = (TextField) -> Bool?

class TextField : UITextField {
    init() {
        super.init(frame: .zero)
        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addUnderlineConstraints(underline)
        delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var responderClosure: ResponderClosure?
    var onSet: ((String) -> Void)?
    
    override func becomeFirstResponder() -> Bool {
       return responderClosure?(self) ?? super.becomeFirstResponder()
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
    let underline = UIView()
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            onSet?(text.replacingCharacters(in: textRange, with: string))
        }
        return true
    }
}
