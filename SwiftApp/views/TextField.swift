//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit


class TextField : UITextField, AtomAView {
    init() {
        super.init(frame: .zero)
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        NSLayoutConstraint.activate(
            underlineConstraints(for: underline)
        )
        delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyAtom(_ atom: Atom, modelStyle: ModelStyle) {
        switch atom {
        case .input(let value, let isSecure, let placeholder, let style, let onSet):
            let textStyle = style ?? modelStyle.text
            self.onSet = onSet
            text = value
            self.placeholder = placeholder
            textColor = textStyle.color
            font = textStyle.font
            textAlignment = textStyle.alignment
            autocapitalizationType = .none
            autocorrectionType = .no
            clearButtonMode = .whileEditing
            isSecureTextEntry = isSecure
            underline.backgroundColor = onSet == nil ? .clear : .lightGray
        default:
            break
        }
    }
    
    private let underline = UIView()
    private var onSet: ((String) -> Void)?
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let newText = text.replacingCharacters(in: textRange, with: string)
            onSet?(newText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onSet?("")
        return true
    }
}
