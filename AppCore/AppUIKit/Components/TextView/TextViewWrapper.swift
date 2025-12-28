//
//  TextViewWrapper.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var characterLimit: Int
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update if not currently editing and text is different
        if !context.coordinator.isEditing {
            if text.isEmpty && !uiView.isFirstResponder {
                uiView.text = placeholder
                uiView.textColor = .placeholderText
            } else if uiView.text != text {
                uiView.text = text
                uiView.textColor = .label
            }
        }
        
        // Sync focus state
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        var isEditing = false
        
        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
            
            // Remove placeholder
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
            isEditing = false
            
            // Show placeholder if empty
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
                parent.text = "" // Make sure binding is empty
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            isEditing = true
            
            // Don't update if it's placeholder text
            if textView.textColor == .placeholderText {
                return
            }
            
            // Enforce character limit
            if textView.text.count > parent.characterLimit {
                textView.text = String(textView.text.prefix(parent.characterLimit))
            }
            
            parent.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // If showing placeholder, allow any input
            if textView.textColor == .placeholderText {
                return true
            }
            
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            // Check character limit
            return updatedText.count <= parent.characterLimit
        }
    }
}
