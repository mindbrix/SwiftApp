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
    
    func become(_ field:  TextField) {
        topConstraint = topAnchor.constraint(equalTo: field.topAnchor)
        text = field.text
        font = field.font
        selectedTextRange = field.selectedTextRange
        underline.backgroundColor = field.underline.backgroundColor
        onSet = field.onSet
        fadeToBackground(from: .red)
    }
    
    var responderClosure: ResponderClosure?
    override func becomeFirstResponder() -> Bool {
       return responderClosure?(self) ?? super.becomeFirstResponder()
    }
    var onSet: ((String) -> Void)?
    var topConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            topConstraint?.isActive = true
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
