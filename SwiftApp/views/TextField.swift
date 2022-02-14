//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var canResign = true
    override var canResignFirstResponder: Bool {
        canResign
    }
    var responderClosure: ResponderClosure?
    override func becomeFirstResponder() -> Bool {
        let didBecome = super.becomeFirstResponder()
        responderClosure?(self)
        return didBecome
    }
    lazy var underline: UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
    }()
}
