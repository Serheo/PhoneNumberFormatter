# Phone Number Formatter

[![Build](https://travis-ci.org/Serheo/PhoneNumberFormatter.svg?branch=master)](https://travis-ci.org/Serheo/PhoneNumberFormatter)
![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

UITextField and NSFormatter subclasses for formatting phone numbers. Allow different formats for different countries(patterns). Caret positioning works excellent.
Swift 4. <br/>
If you need ObjC support use - https://github.com/Serheo/SHSPhoneComponent/

## Installation

#### Carthage
```
github "Serheo/PhoneNumberFormatter"
```
#### CocoaPods
```
pod "SwiftPhoneNumberFormatter"
```

## Getting Started

### Default Format
```swift
textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
```
All input strings will be parsed in that way. 
Example: +1 (123) 123-45-67

<p align="center">
    <img src="https://thumbs.gfycat.com/VerifiablePolishedGazelle-max-14mb.gif" alt="Image"/>
</p>

### Prefix Format
You can set prefix on all inputs:
```swift
textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
textField.prefix = "+7 "
```

### Multiple Formats

```swift
textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "##########")
textField.prefix = nil
let custom1 = PhoneFormat(phoneFormat: "+# (###) ###-##-##", regexp: "^7[0-689]\\d*$")
textField.config.add(format: custom1)

let custom2 = PhoneFormat(phoneFormat: "+### ###-##-##", regexp: "^380\\d*$")
textField.config.add(format: custom2)
```

### Multiple Formats with prefix

```swift
textField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### ### ###")
textField.prefix = "+7 "

let custom1 = PhoneFormat(phoneFormat: "(###) ###-##-##", regexp: "^1\\d*$")
textField.config.add(format: custom1)

let custom2 = PhoneFormat(phoneFormat: "(###) ###-###", regexp: "^2\\d*$")
textField.config.add(format: custom2)
```

### Listening to changes
To be notified of changes on the textField input add a `textDidChangeBlock` closure
```swift
textField.textDidChangeBlock = { field in
  if let text = field?.text, text != "" {
      print(text)
  } else {
      print("No text")
  }
```

Attempting to listen to changes through other means will likely fail (e.g., implementing `UITextFieldDelegate`'s `textField:shouldChangeCharactersIn:range:`).

## Requirements
iOS 9+
Swift 4

## License
PhoneNumberFormatter is available under the MIT license. See the LICENSE file for more info.
