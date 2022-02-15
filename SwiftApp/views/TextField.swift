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
        NSLayoutConstraint.activate([
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 0.5)
        ])
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
        textColor = field.textColor
        font = field.font
        selectedTextRange = field.selectedTextRange
        underline.backgroundColor = field.underline.backgroundColor
        onSet = field.onSet
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            leadingConstraint?.isActive = true
        }
    }
    var topConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            topConstraint?.isActive = true
        }
    }
    var trailngConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            trailngConstraint?.isActive = true
        }
    }
    
    lazy var underline: UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
    }()
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            onSet?(text.replacingCharacters(in: textRange, with: string))
        }
        return true
    }
}
