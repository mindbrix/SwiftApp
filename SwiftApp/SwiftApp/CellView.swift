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
    
    var cell: Cell? {
        didSet {
            setupStack()
            applyColors()
            applyStyle()
            applyModel()
        }
    }
    
    static let defaultStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    static let thumbSize: CGFloat = 64
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
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
        case .header(let title):
            label0.text = title
        case .image(let get, let caption, _, _):
            image.image = get()
            label0.text = caption
        case .standard(let title, let body, _):
            label0.text = title
            label1.text = body
        case .textInput(let title, let get, _):
            label0.text = title
            textField.text = get()
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
            backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }
    
    private func applyStyle() {
        heightConstraint?.isActive = false
        let fontSize: CGFloat = 14
        guard let cell = cell else { return }
        switch cell {
        case .button(_, _):
            label0.font = .systemFont(ofSize: fontSize * 1.33, weight: .medium)
            label0.textAlignment = .center
        case .header( _):
            label0.font = .systemFont(ofSize: fontSize, weight: .regular)
            label0.textAlignment = .left
        case .image(let get, _, _, let isThumbnail):
            if let size = get()?.size {
                heightConstraint = image.heightAnchor.constraint(
                    equalTo: image.widthAnchor,
                    multiplier: size.height / size.width)
                widthConstraint.isActive = isThumbnail
                heightConstraint?.isActive = true
            }
            label0.font = .systemFont(ofSize: fontSize, weight: .regular)
            label0.textAlignment = .left
        case .standard(_, _, _):
            label0.font = .systemFont(ofSize: fontSize * 1.2, weight: .regular)
            label0.textAlignment = .left
            label1.font = .systemFont(ofSize: fontSize, weight: .regular)
            label1.textAlignment = .left
        case .textInput(_, _, _):
            label0.font = .systemFont(ofSize: fontSize * 0.866, weight: .regular)
            label0.textAlignment = .left
            textField.font = .systemFont(ofSize: fontSize * 1.2, weight: .regular)
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
                set(text.replacingCharacters(in: textRange, with: string))
            }
        default:
            break
        }
        return true
    }
}
