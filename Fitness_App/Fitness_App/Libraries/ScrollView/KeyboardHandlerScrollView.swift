//
//  KeyboardHandlerScrollView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

typealias KeyboardFrameResponse = ((_ frame: CGRect) -> Void)
enum KeyboardPresenterStates {
    case willShow, didShow, willHide, didHide
}

class KeyboardHandlerScrollView: UIScrollView {
    
    // MARK: - Variables
    var changeInsetsWhenKeyboardWillShow = true
    var changeInsetsWhenKeyboardDidShow = false
    var changeInsetsWhenKeyboardWillHide = true
    var changeInsetsWhenKeyboardDidHide = false
    var tapToEndEditing = true {
        didSet {
            if tapToEndEditing {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapGesture(sender:)))
                addGestureRecognizer(tapGesture)
            } else {
                gestureRecognizers?.filter({ $0 is UITapGestureRecognizer }).forEach { removeGestureRecognizer($0) }
            }
        }
    }
    private var isShowingKeyboard = false
    private var originBottomInset: CGFloat = 0
    
    // MARK: - Closure
    var keyboardWillShow: KeyboardFrameResponse?
    var keyboardDidShow: KeyboardFrameResponse?
    var keyboardWillHide: KeyboardFrameResponse?
    var keyboardDidHide: KeyboardFrameResponse?
    
    // MARK: - Init & deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Builder
    @discardableResult
    func willShow(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardWillShow = handler
        return self
    }
    
    @discardableResult
    func didShow(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardDidShow = handler
        return self
    }
    
    @discardableResult
    func willHide(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardWillHide = handler
        return self
    }
    
    @discardableResult
    func didHide(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardDidHide = handler
        return self
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        setupScrollView()
        detectKeyboardStates()
    }
    
    private func setupScrollView() {
        contentInset = .zero
        tapToEndEditing = true
    }
    
    // MARK: - Action
    func detectKeyboardStates() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(noti:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHideNotification(noti:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardWillShow else { return }
        if !isShowingKeyboard {
            originBottomInset = contentInset.bottom
        }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        isShowingKeyboard = true
        keyboardWillShow?(keyboardRect)
    }
    
    @objc private func keyboardDidShowNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardDidShow else { return }
        if !isShowingKeyboard {
            originBottomInset = contentInset.bottom
        }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        isShowingKeyboard = true
        keyboardDidShow?(keyboardRect)
    }
    
    @objc private func keyboardWillHideNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardWillHide else { return }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: originBottomInset, right: 0)
        isShowingKeyboard = false
        keyboardWillHide?(keyboardRect)
    }
    
    @objc private func keyboardDidHideNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardDidHide else { return }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: originBottomInset, right: 0)
        isShowingKeyboard = false
        keyboardDidHide?(keyboardRect)
    }
    
    @objc private func scrollViewTapGesture(sender: UITapGestureRecognizer) {
        if tapToEndEditing { endEditing(true) }
    }
}
