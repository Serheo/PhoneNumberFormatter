//
//  TextFieldTests.swift
//  PhoneNumberFormatterTests
//
//  Created by Sergey Shatunov on 9/3/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import XCTest
@testable import PhoneNumberFormatter

class TextFieldTests: XCTestCase {

    func testShouldSetFormattedText() {
        let textField = PhoneFormattedTextField(frame: CGRect.zero)
        textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "+# (###) ###-##-##")
        textField.formattedText = "12312312323555555"
        XCTAssert(textField.text == "+1 (231) 231-23-23", "Should be formatted")
    }

}
