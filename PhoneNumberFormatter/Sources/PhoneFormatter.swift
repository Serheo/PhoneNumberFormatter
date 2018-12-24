//
//  PhoneFormatter.swift
//  PhoneNumberFormatter
//
//  Created by Sergey Shatunov on 8/20/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import UIKit

struct PhoneFormatterResult {
    let text: String

    init(text: String) {
        self.text = text
    }
}

final class PhoneFormatter {

    let config: ConfigurationRepo
    init(config: ConfigurationRepo) {
        self.config = config
    }

    private let patternSymbol: Character = "#"
    private func isRequireSubstitute(char: Character) -> Bool {
        return patternSymbol == char
    }

    private let valuableChars: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    func isValuableChar(char: Character) -> Bool {
        return valuableChars.contains(char) ? true : false
    }

    func digitOnlyString(text: String?) -> String? {
        guard let text = text else {
            return nil
        }

        if let regex = try? NSRegularExpression(pattern: "\\D",
                                                options: [NSRegularExpression.Options.caseInsensitive]) {
            let range = NSRange(location: 0, length: text.count)
            return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        }
        return nil
    }

    private func isMatched(text: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return false
        }

        let range = NSRange(location: 0, length: text.count)
        let match = regex.firstMatch(in: text, options: [], range: range)
        if let matchObject = match, matchObject.range.location != NSNotFound {
            return true
        } else {
            return false
        }
    }

    private func getAppropriateConfig(text: String, in repo: ConfigurationRepo) -> PhoneFormat {
        for item in config.getUserConfigs() {
            if isMatched(text: text, pattern: item.regexp) {
                return item
            }
        }
        return repo.getDefaultConfig()
    }

    func formatText(text: String, prefix: String? = nil) -> PhoneFormatterResult {
        let lastPossibleFormat = getAppropriateConfig(text: text, in: config)

        let cleanNumber = removeFormatFrom(text: text, format: lastPossibleFormat, prefix: prefix) ?? ""

        let appropriateConfig = getAppropriateConfig(text: cleanNumber, in: config)
        let result = applyFormat(text: cleanNumber, format: appropriateConfig, prefix: prefix)
        return PhoneFormatterResult(text: result)
    }

    func formattedRemove(text: String, range: NSRange) -> String {
        var possibleString = Array(text)
        let rangeExpressionStart = text.index(text.startIndex, offsetBy: range.location)
        let rangeExpressionEnd = text.index(text.startIndex, offsetBy: range.location + range.length)

        let targetSubstring = text[rangeExpressionStart..<rangeExpressionEnd]
        var removeCount = valuableCharCount(in: targetSubstring)
        if range.length == 1 {
            removeCount = 1
        }

        for wordCount in 0..<removeCount {
            for idx in (0...(range.location + range.length - wordCount - 1)).reversed() {
                if isValuableChar(char: possibleString[idx]) {
                    possibleString.remove(at: idx)
                    break
                }
            }
        }
        return String(possibleString)
    }

    private func removeFormatFrom(text: String, format: PhoneFormat, prefix: String?) -> String? {
        var unprefixedString = text
        if let prefixString = prefix, unprefixedString.hasPrefix(prefixString) {
            unprefixedString.removeFirst(prefixString.count)
        }

        let phoneFormat = format.phoneFormat
        var removeRanges: [NSRange] = []

        let min = [text.count, format.phoneFormat.count].min() ?? 0
        for idx in 0 ..< min {
            let index = phoneFormat.index(phoneFormat.startIndex, offsetBy: idx)
            let formatChar = phoneFormat[index]
            if formatChar != text[index] {
                break
            }

            if isValuableChar(char: formatChar) {
                let newRange = NSRange(location: idx, length: 1)
                removeRanges.append(newRange)
            }
        }
        var resultText = unprefixedString
        for range in removeRanges.reversed() {
            let rangeExpressionStart = resultText.index(resultText.startIndex, offsetBy: range.location)
            let rangeExpressionEnd = resultText.index(resultText.startIndex, offsetBy: range.location + 1)
            resultText = resultText.replacingCharacters(in: rangeExpressionStart...rangeExpressionEnd, with: "")
        }

        return digitOnlyString(text: resultText)
    }

    func valuableCharCount(in text: String.SubSequence) -> Int {
        let count = text.reduce(0) { (result, item) -> Int in
            if isValuableChar(char: item) {
                return result + 1
            } else {
                return result
            }
        }
        return count
    }

    private func applyFormat(text: String, format: PhoneFormat, prefix: String?) -> String {
        var result: [Character] = []

        var idx = 0
        var charIndex = 0
        let phoneFormat = format.phoneFormat
        while idx < phoneFormat.count && charIndex < text.count {
            let index = phoneFormat.index(phoneFormat.startIndex, offsetBy: idx)
            let character = phoneFormat[index]
            if isRequireSubstitute(char: character) {
                let charIndexItem = text.index(text.startIndex, offsetBy: charIndex)
                let strp = text[charIndexItem]
                charIndex += 1
                result.append(strp)
            } else {
                result.append(character)
            }
            idx += 1
        }
        return (prefix ?? "") + String(result)
    }

    func pushCaretPosition(text: String?, range: NSRange) -> Int {
        guard let text = text else {
            return 0
        }

        let index = text.index(text.startIndex, offsetBy: range.location + range.length)
        let subString = text[index...]
        return valuableCharCount(in: subString)
    }

    func popCaretPosition(textField: UITextField, range: NSRange, caretPosition: Int)
                            -> (startPosition: UITextPosition, endPosition: UITextPosition)? {
        var currentRange: NSRange = range
        if range.length == 0 {
            currentRange.length = 1
        }

        let text = textField.text ?? ""
        var lasts = caretPosition
        var start = text.count
        var index = start - 1

        while start >= 0 && lasts > 0 {
            let indexChar = text.index(text.startIndex, offsetBy: index)
            let character = text[indexChar]
            if isValuableChar(char: character) {
                lasts -= 1
            }

            if lasts <= 0 {
                start = index
            }
            index -= 1
        }

        if let startPosition = textField.position(from: textField.beginningOfDocument, offset: start),
            let endPosition = textField.position(from: startPosition, offset: 0) {
            return (startPosition, endPosition)
        } else {
            return nil
        }
    }
}
