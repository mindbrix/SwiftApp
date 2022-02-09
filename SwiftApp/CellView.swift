//
//  CellView.swift
//  SwiftApp
//
//  Created by Nigel Barber on 07/02/2022.
//

import Foundation
import UIKit

class CellView: UIView, UITextFieldDelegate {
    init() {
        super.init(frame: .zero)
        addSubview(stack)
        stack.constrainToSuperview(insets: Self.defaultStackInsets)
        stack.addGestureRecognizer(tapper)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(cell: Cell, style: FontStyle) {
        self.cell = cell
        setupStack()
        applyColors()
        applyStyle(style: style)
        applyModel()
    }
    private var cell: Cell?

    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    static let thumbSize: CGFloat = 64
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
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
    lazy var widthConstraint: NSLayoutConstraint = {
        image.widthAnchor.constraint(equalToConstant: Self.thumbSize)
    }()
    var heightConstraint: NSLayoutConstraint?
    
    private func setupStack() {
        for subview in stack.subviews {
            subview.removeFromSuperview()
        }
        stack.axis = .vertical
        stack.alignment = .fill
        guard let cell = cell else { return }
        switch cell {
        case .button:
            stack.addArrangedSubview(label0)
        case .header:
            stack.addArrangedSubview(label0)
        case .image(_, _, _, let isThumbnail):
            stack.axis = isThumbnail ? .horizontal : .vertical
            stack.alignment = isThumbnail ? .leading : .fill
            stack.addArrangedSubview(image)
            stack.addArrangedSubview(label0)
        case .standard:
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(label1)
        case .textInput:
            stack.addArrangedSubview(label0)
            stack.addArrangedSubview(textField)
        }
    }
    private func applyModel() {
        guard let cell = cell else { return }
        switch cell {
        case .button(let title, _):
            label0.text = title
        case .header(let caption):
            label0.text = caption
        case .image(let get, let caption, _, _):
            image.image = get()
            label0.text = caption
        case .standard(let title, let caption, _):
            label0.text = title
            label1.text = caption
        case .textInput(let key, let get, let set):
            label0.text = key
            textField.text = get()
            textField.isUserInteractionEnabled = set != nil
        }
    }
    
    private func applyColors() {
        guard let cell = cell else { return }
        switch cell {
        case .button:
            backgroundColor = .red
        case .header:
            backgroundColor = UIColor(white: 0.9, alpha: 1)
        case .image:
            backgroundColor = .white
        case .standard:
            backgroundColor = .white
        case .textInput:
            backgroundColor = .white
        }
    }
    
    private func applyStyle(style: FontStyle) {
        heightConstraint?.isActive = false
        let titleFont = UIFont(name: style.name, size: style.size * 1.2)
        let captionFont = UIFont(name: style.name, size: style.size * 1.0)
        let keyFont = UIFont(name: style.name, size: style.size * 0.866)
        let valueFont = titleFont
        
        guard let cell = cell else { return }
        switch cell {
        case .button(_, _):
            label0.font = titleFont
            label0.textAlignment = .center
        case .header:
            label0.font = captionFont
            label0.textAlignment = .left
        case .image(let get, _, _, let isThumbnail):
            if let size = get()?.size {
                heightConstraint = image.heightAnchor.constraint(
                    lessThanOrEqualTo: image.widthAnchor,
                    multiplier: size.height / size.width)
                widthConstraint.isActive = isThumbnail
                heightConstraint?.isActive = true
            }
            label0.font = captionFont
            label0.textAlignment = .left
        case .standard(_, _, _):
            label0.font = titleFont
            label0.textAlignment = .left
            label1.font = captionFont
            label1.textAlignment = .left
        case .textInput(_, _, _):
            label0.font = keyFont
            label0.textAlignment = .left
            textField.font = valueFont
            textField.textAlignment = .left
        }
    }
    
    @objc func onTap() {
        guard let cell = cell else { return }
        switch cell {
        case .button(_, let onTap):
            onTap()
        case .header:
            break
        case .image(_, _, let onTap, _):
            onTap?()
        case .standard(_, _, let onTap):
            onTap?()
        case .textInput:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch cell {
        case .textInput(_, _, let set):
            if let text = textField.text, let textRange = Range(range, in: text) {
                set?(text.replacingCharacters(in: textRange, with: string))
            }
        default:
            break
        }
        return true
    }
}
