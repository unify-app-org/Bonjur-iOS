//
//  KeyboardDoneAccessory.swift
//  AppUIKit
//
//  UIToolbar factory for a "Done" keyboard accessory. SwiftUI text fields get
//  their Done bar from `KeyboardAccessoryHost` (the feature-screen root toolbar)
//  but a UIKit `UITextView` responder is not reached by SwiftUI's keyboard
//  toolbar, so the `TextView` wrapper sets this directly as its
//  `inputAccessoryView`.
//

import UIKit

/// Builds a keyboard "Done" toolbar. Pass an explicit `target`/`action` when the
/// responder chain alone can't dismiss the field (e.g. a `UITextView` whose
/// SwiftUI focus binding would otherwise re-focus it). System `.done` is
/// localized by iOS automatically.
public func makeDoneToolbar(
    target: Any? = nil,
    action: Selector = #selector(UIResponder.resignFirstResponder)
) -> UIToolbar {
    let toolbar = UIToolbar(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    )
    let flexible = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
    )
    let done = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: target,
        action: action
    )
    toolbar.items = [flexible, done]
    toolbar.sizeToFit()
    return toolbar
}
