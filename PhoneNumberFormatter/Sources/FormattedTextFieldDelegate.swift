//
//  FormattedTextFieldDelegate.swift
//  PhoneNumberFormatter
//
//  Created by Sergey Shatunov on 8/20/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import UIKit

final class FormattedTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var userDelegate: UITextFieldDelegate?

    var textDidChangeBlock: ((_ textField: UITextField?) -> Void)?
    var prefix: String?
    var hasPredictiveInput: Bool = true

    private let formatter: PhoneFormatter
    init(formatter: PhoneFormatter) {
        self.formatter = formatter
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let prefix = prefix, range.location < prefix.count {
            return false
        }

        let resultText = textField.text ?? ""
        let caretPosition = formatter.pushCaretPosition(text: resultText, range: range)

        let isDeleting = string.count == 0
        let newString: String
        if isDeleting {
            newString = formatter.formattedRemove(text: resultText, range: range)
        } else {
            let rangeExpressionStart = resultText.index(resultText.startIndex, offsetBy: range.location)
            let rangeExpressionEnd = resultText.index(resultText.startIndex, offsetBy: range.location + range.length)
            newString = resultText.replacingCharacters(in: rangeExpressionStart..<rangeExpressionEnd, with: string)
        }

        let result = formatter.formatText(text: newString, prefix: prefix)
        textField.text = result.text

        if let positionRange = formatter.popCaretPosition(textField: textField,
                                                          range: range,
                                                          caretPosition: caretPosition) {
            textField.selectedTextRange = textField.textRange(from: positionRange.startPosition,
                                                              to: positionRange.endPosition)
        }

        self.textDidChangeBlock?(textField)
        textField.sendActions(for: .valueChanged)

        if hasPredictiveInput == true && (textField.text == nil || textField.text == "") && string == " " {
            return true
        } else {
            return false
        }
    }

    // MARK: UITextfield Delegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return userDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        userDelegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return userDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

     func textFieldDidEndEditing(_ textField: UITextField) {
        userDelegate?.textFieldDidEndEditing?(textField)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let userResult = userDelegate?.textFieldShouldClear?(textField) {
            return userResult
        }

        if let prefix = prefix {
            textField.text = prefix
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return userDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}
