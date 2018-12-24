//
//  ViewController.swift
//  Demo
//
//  Created by Sergey Shatunov on 8/30/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import UIKit
import PhoneNumberFormatter

class ViewController: UIViewController {

    @IBOutlet weak var textField: PhoneFormattedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()

        textField.textDidChangeBlock = { field in
            if let text = field?.text, text != "" {
                print(text)
            } else {
                print("No text")
            }

        }

        defaultExample()
    }

    func defaultExample() {
        textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "# (###) ###-##-##")
    }

    func prefixExample() {
        textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        textField.prefix = "+7 "
        let custom = PhoneFormat(phoneFormat: "(###) ###-##-##", regexp: "^[0-689]\\d*$")
        textField.config.add(format: custom)
    }

    func doubleFormatExample() {
        textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "##########")
        textField.prefix = nil
        let custom1 = PhoneFormat(phoneFormat: "+# (###) ###-##-##", regexp: "^7[0-689]\\d*$")
        textField.config.add(format: custom1)

        let custom2 = PhoneFormat(phoneFormat: "+### ###-##-##", regexp: "^380\\d*$")
        textField.config.add(format: custom2)
    }

    func doubleFormatExamplePrefixed() {
        textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### ### ###")
        textField.prefix = "+7 "

        let custom1 = PhoneFormat(phoneFormat: "(###) ###-##-##", regexp: "^1\\d*$")
        textField.config.add(format: custom1)

        let custom2 = PhoneFormat(phoneFormat: "(###) ###-###", regexp: "^2\\d*$")
        textField.config.add(format: custom2)
    }

}
