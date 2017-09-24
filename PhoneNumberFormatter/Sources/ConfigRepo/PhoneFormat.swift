//
//  PhoneFormat.swift
//  PhoneNumberFormatter
//
//  Created by Sergey Shatunov on 8/20/17.
//  Copyright © 2017 SHS. All rights reserved.
//

import UIKit

/**
 Phone Format Class. Conatin format and related regexp
*/
public struct PhoneFormat {

    /**
     Phone format
     */
    public let phoneFormat: String

    /**
     Phone regexp for the format
     */
    public let regexp: String

    public init(defaultPhoneFormat: String) {
        self.phoneFormat = defaultPhoneFormat
        self.regexp = "*"
    }

    public init(phoneFormat: String, regexp: String) {
        self.phoneFormat = phoneFormat
        self.regexp = regexp
    }
}
