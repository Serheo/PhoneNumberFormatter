//
//  FormatterTests.swift
//  PhoneNumberFormatterTests
//
//  Created by Sergey Shatunov on 9/3/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import XCTest
@testable import PhoneNumberFormatter

class FormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testShouldFormatByDefault() {
        let defaultFormat = PhoneFormat(defaultPhoneFormat: "+# (###) ###-##-##")
        let config = ConfigurationRepo(defaultFormat: defaultFormat)
        let inputNumber = "12345678901"

        let formatter = PhoneFormatter(config: config)

        var result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+1 (234) 567-89-01", "Should format correctly")

        formatter.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "+# (###) ###-####")
        result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+1 (234) 567-8901", "Should format correctly")
    }

    func testShouldDetectSpecificFormats() {
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "+# (###) ###-##-##"))
        config.add(format: PhoneFormat(phoneFormat: "+### (##) ###-##-##", regexp: "^380\\d*$"))

        let formatter = PhoneFormatter(config: config)

        let inputNumber = "12345678901"
        let specififcInputNumber = "38012345678901"

        var result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+1 (234) 567-89-01", "Should format number by default")

        result = formatter.formatText(text: specififcInputNumber, prefix: nil)
        XCTAssert(result.text == "+380 (12) 345-67-89", "specififcInputNumber")
    }

    func testShouldHandleSpecialSymbols() {
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "+# (###) ###-##-##"))
        let formatter = PhoneFormatter(config: config)

        var inputNumber = "!#dsti*&"
        var result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "", "should remove non-number symbols")

        inputNumber = "+12345678901"
        result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+1 (234) 567-89-01", "should format number by default and handle + symbol")
    }

    func testShouldHandleFormatWithDigitsAtStart() {
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "+7 (###) ###-##-##"))
        let formatter = PhoneFormatter(config: config)

        var inputNumber = "9201234567"
        var result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+7 (920) 123-45-67", "should format correctly")

        inputNumber = "7777778877"
        result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "+7 (777) 777-88-77", "should format correctly")
    }

    func testShouldHandleFormatWithDigitsInTheMiddle() {
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "### 123 ##-##"))
        let formatter = PhoneFormatter(config: config)

        var inputNumber = "3211231"
        var result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "321 123 12-31", "should format correctly")

        inputNumber = "1113333"
        result = formatter.formatText(text: inputNumber, prefix: nil)
        XCTAssert(result.text == "111 123 33-33", "should format correctly")
    }

    func testShouldCheckPrefix() {
        let prefix = "pr3f1x"
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "(###) ###-##-##"))
        let formatter = PhoneFormatter(config: config)

        let inputNumber = "9201234567"
        let result = formatter.formatText(text: inputNumber, prefix: prefix)
        XCTAssert(result.text == prefix + "(920) 123-45-67", "should format correctly")
    }

    func testShouldCheckPrefixAndDifferentFormats() {
        let prefix = "pr3-f1x"
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "##########"))
        config.add(format: PhoneFormat(phoneFormat: "+### (##) ###-##-##", regexp: "^380\\d*$"))
        config.add(format: PhoneFormat(phoneFormat: "+### (##) ###-##-##", regexp: "^123\\d*$"))
        let formatter = PhoneFormatter(config: config)

        let inputNumber = "3801234567"
        let inputNumberNonImage = "1231234567"
        var result = formatter.formatText(text: inputNumber, prefix: prefix)
        XCTAssert(result.text == prefix + "+380 (12) 345-67", "should format correctly")

        result = formatter.formatText(text: inputNumberNonImage, prefix: prefix)
        XCTAssert(result.text == prefix + "+123 (12) 345-67", "should format correctly")
    }

    func testShouldHandleNumberFormatStyles() {
        let prefix: String? = nil
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "+78 (###) ###-##-##"))
        let formatter = PhoneFormatter(config: config)

        var result = formatter.formatText(text: "+7 (123", prefix: prefix)
        XCTAssert(result.text == "+78 (123", "should format correctly")

        result = formatter.formatText(text: "+87 (1234", prefix: prefix)
        XCTAssert(result.text == "+78 (871) 234", "should format correctly")

        formatter.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "+7 (###) 88#-##-##")

        result = formatter.formatText(text: "+7 (123", prefix: prefix)
        XCTAssert(result.text == "+7 (123", "should format correctly")

        result = formatter.formatText(text: "1234", prefix: prefix)
        XCTAssert(result.text == "+7 (123) 884", "should format correctly")

        result = formatter.formatText(text: "+7 (123) 884", prefix: prefix)
        XCTAssert(result.text == "+7 (123) 888-84", "should format correctly")

        result = formatter.formatText(text: "+7 (123) 8887", prefix: prefix)
        XCTAssert(result.text == "+7 (123) 888-88-7", "should format correctly")
    }

    func testShouldHandlePrefixNumberFormatStyles() {
        let prefix: String = "pr3-f1x "
        let config = ConfigurationRepo(defaultFormat: PhoneFormat(defaultPhoneFormat: "+7 (###) 88#-##-##"))
        let formatter = PhoneFormatter(config: config)

        var result = formatter.formatText(text: "+7 (123", prefix: prefix)
        XCTAssert(result.text == prefix + "+7 (123", "should format correctly")

        result = formatter.formatText(text: "+7 (123) 8887", prefix: prefix)
        XCTAssert(result.text == prefix + "+7 (123) 888-88-7", "should format correctly")
    }
}
