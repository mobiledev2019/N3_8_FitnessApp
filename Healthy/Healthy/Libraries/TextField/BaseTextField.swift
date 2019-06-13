//
//  BaseTextField.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {

    // MARK: - Typealias
    typealias TextDidChangeResponse = ((_ newText: String?) -> Void)
    typealias TextStateResponse = (() -> Void)
    
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
        setupTextField()
    }
    
    // MARK: - Setup functions
    private func setupTextField() {
        delegate = self
        clipsToBounds = true
        addTarget(self, action: #selector(textFieldDidChangeText(sender:)), for: .editingChanged)
    }
    
    // MARK: - Action
    @objc private func textFieldDidChangeText(sender: UITextField) {
        textDidChangeHandler?(sender.text)
    }
    
    // MARK: - Builder
    @discardableResult
    func set(text: String) -> BaseTextField {
        self.text = text
        textFieldDidChangeText(sender: self)
        return self
    }
    
    @discardableResult
    func maxCharacters(count: Int) -> BaseTextField {
        maxCharCount = count
        return self
    }
    
    @discardableResult
    func maxBytes(count: Int) -> BaseTextField {
        maxBytes = count
        return self
    }
    
    @discardableResult
    func textDidChange(handler: @escaping TextDidChangeResponse) -> BaseTextField {
        textDidChangeHandler = handler
        return self
    }
    
    @discardableResult
    func didBeginEditing(handler: @escaping TextStateResponse) -> BaseTextField {
        didBeginEditingHandler = handler
        return self
    }
    
    @discardableResult
    func didEndEditing(handler: @escaping TextStateResponse) -> BaseTextField {
        didEndEditingHandler = handler
        return self
    }
}

extension BaseTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        if let maxCharCount = maxCharCount {
            return newText.count <= maxCharCount
        } else if let maxBytes = maxBytes, let currentBytes = newText.getBytesBy(encoding: SystemInfo.shiftJISEncoding) {
            return currentBytes <= maxBytes
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditingHandler?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditingHandler?()
    }
}
