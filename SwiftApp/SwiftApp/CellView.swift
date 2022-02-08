//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

class CellView: UIView, UITextFieldDelegate {
    init(cell: Cell? = nil) {
        super.init(frame: .zero)
        addSubview(stack)
        stack.constrainToSuperview(insets: Self.defaultStackInsets)
        stack.addGestureRecognizer(tapper)
        self.cell = cell
        applyCell()
        applyCellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cell: Cell? {
        didSet {
            applyCell()
            applyCellStyle()
        }
    }
    
    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        let size: CGFloat = 64
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: size),
            image.heightAnchor.constraint(equalToConstant: size)
        ])
        return image
    }()
    lazy var label0: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var label1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var tapper: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(onTap))
    }()
    lazy var textField: UITextField = {
        let field = UITextField()
        field.delegate = self
        return field
    }()
    
    private func applyCell() {
        for subview in stack.subviews {
            subview.removeFromSuperview()
        }
        guard let cell = cell else { return }
        
        stack.axis = .vertical
        stack.alignment = .fill
        switch cell {
        case .button(let title, _):
            stack.addArrangedSubview(label0)
            label0.text = title
        case .header(let title):
            stack.addArrangedSubview(label0)
            label0.text = title
        case .standard(let title, let body, _):
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(label1)
            label0.text = title
            label1.text = body
        case .textInput(let title, let get, _):
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(textField)
            label0.text = title
            textField.text = get()
        case .thumbnail(let get, let caption, _):
            stack.axis = .horizontal
            stack.alignment = .leading
            stack.addArrangedSubview(image)
            stack.addArrangedSubview(label0)
            image.image = get()
            label0.text = caption
        }
    }
    
    private func applyCellStyle() {
        guard let cell = cell else { return }
        
        let fontSize: CGFloat = 14
        switch cell {
        case .button(_, _):
            label0.textAlignment = .center
            label0.font = UIFont.systemFont(ofSize: fontSize * 1.33, weight: .medium)
            backgroundColor = .red
        case .header( _):
            label0.textAlignment = .left
            label0.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            backgroundColor = UIColor(white: 0.9, alpha: 1)
        case .standard(_, _, _):
            label0.textAlignment = .left
            label0.font = UIFont.systemFont(ofSize: fontSize * 1.2, weight: .regular)
            label1.textAlignment = .left
            label1.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            backgroundColor = .white
        case .textInput(_, _, _):
            label0.font = UIFont.systemFont(ofSize: fontSize * 0.866, weight: .regular)
            label0.textAlignment = .left
            textField.font = UIFont.systemFont(ofSize: fontSize * 1.2, weight: .regular)
            textField.textAlignment = .left
            backgroundColor = UIColor(white: 0.95, alpha: 1)
        case .thumbnail:
            label0.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            label0.textAlignment = .left
            backgroundColor = .white
        }
    }
    
    @objc func onTap() {
        guard let cell = cell else { return }
        
        switch cell {
        case .button(_, let onTap):
            onTap()
        case .header( _):
            break
        case .standard(_, _, let onTap):
            onTap?()
        case .textInput(_, _, _):
            break
        case .thumbnail(_, _, let onTap):
            onTap?()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch cell {
        case .textInput(_, _, let set):
            if let text = textField.text, let textRange = Range(range, in: text) {
                set(text.replacingCharacters(in: textRange, with: string))
            }
        default:
            break
        }
        return true
    }
}
