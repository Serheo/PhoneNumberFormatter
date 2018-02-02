//
//  ConfigurationRepo.swift
//  PhoneNumberFormatter
//
//  Created by Sergey Shatunov on 8/20/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import UIKit

/**
 List of all possible formatters of the TextField.
 Contains at least default one.
*/
final public class ConfigurationRepo {

    private var customConfigs: [PhoneFormat] = []

    /**
      Default configuration
     */
    public var defaultConfiguration: PhoneFormat = PhoneFormat(defaultPhoneFormat: "#############")

    init() {
    }

    init(defaultFormat: PhoneFormat) {
        self.defaultConfiguration = defaultFormat
    }

    func getDefaultConfig() -> PhoneFormat {
        return defaultConfiguration
    }

    func getUserConfigs() -> [PhoneFormat] {
        return customConfigs
    }

    /**
      Add new custom format
     */
    public func add(format: PhoneFormat) {
        customConfigs.append(format)
    }
}
