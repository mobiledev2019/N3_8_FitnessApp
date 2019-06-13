//
//  BaseTextView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    
    // MARK: - Outlets
    fileprivate weak var textHintLabel: UILabel?
    
    // MARK: - Typealias
    typealias TextDidChangeResponse = ((_ newText: String) -> Void)
    typealias TextStateResponse = (() -> Void)
    
    // MARK: - Constants
    private var padding = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    
    // MARK: - Variables
    fileprivate var maxCharCount: Int?
    fileprivate var maxBytes: Int?
    
    // MARK: - Closures
    fileprivate var textDidChangeHandler: TextDidChangeResponse?
    fileprivate var didBeginEditingHandler: TextStateResponse?
    fileprivate var didEndEditingHandler: TextStateResponse?
    
    // MARK: - Draw functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addTextHintLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let label = textHintLabel {
            guard let _ = constraints.filter({ $0.firstAttribute == .width && ($0.firstItem as? UILabel) == label }).first else {
                addConstraint(AutoLayoutHelper.fixedConstraint(label, attribute: .width, value: bounds.width - padding.left - padding.right - 6))
                return
            }
        }
    }
    
    // MARK: - Setup functions
    private func setupTextView() {
        delegate = self
        clipsToBounds = true
        textContainerInset = UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
    }
    
    override func firstRect(for range: UITextRange) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func addTextHintLabel() {
        let label = UILabel()
        label.font = UIFont.normal(size: 13)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        addSubview(label)
        
        let constraints: [NSLayoutConstraint] = [
            AutoLayoutHelper.equalConstraint(label, superView: self, attribute: .top, constant: padding.top + 2),
            AutoLayoutHelper.equalConstraint(label, superView: self, attribute: .left, constant: padding.left + 4),
        ]
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints)
        
        textHintLabel = label
    }
    
    // MARK: - Builder
    @discardableResult
    func set(placeHolder: String) -> BaseTextView {
        textHintLabel?.text = placeHolder
        layoutIfNeeded()
        setNeedsDisplay()
        return self
    }
    
    @discardableResult
    func set(text: String) -> BaseTextView {
        self.text = text
        textViewDidChange(self)
        return self
    }
    
    @discardableResult
    func set(padding: UIEdgeInsets) -> BaseTextView {
        self.padding = padding
        textViewDidChange(self)
        return self
    }
    
    @discardableResult
    func maxCharacters(count: Int) -> BaseTextView {
        maxCharCount = count
        return self
    }
    
    @discardableResult
    func maxBytes(count: Int) -> BaseTextView {
        maxBytes = count
        return self
    }
    
    @discardableResult
    func textDidChange(handler: @escaping TextDidChangeResponse) -> BaseTextView {
        textDidChangeHandler = handler
        return self
    }
    
    @discardableResult
    func didBeginEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didBeginEditingHandler = handler
        return self
    }
    
    @discardableResult
    func didEndEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didEndEditingHandler = handler
        return self
    }
    
    // MARK: - Update UI
    fileprivate func togglePlaceholderLabelBy(text: String) {
        guard let label = textHintLabel else { return }
        let isHidden = text != ""
        label.isHidden = isHidden
        if !isHidden { bringSubviewToFront(label) }
    }
}

extension BaseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Check to show or hide placeholder label
        togglePlaceholderLabelBy(text: textView.text)
        textDidChangeHandler?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if let maxCharCount = maxCharCount {
            return newText.count <= maxCharCount
        } else if let maxBytes = maxBytes, let currentBytes = newText.getBytesBy(encoding: SystemInfo.shiftJISEncoding) {
            return currentBytes <= maxBytes
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditingHandler?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditingHandler?()
    }
}
