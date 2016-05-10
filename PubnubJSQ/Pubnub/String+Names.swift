//
//  String+Names.swift
//  TwilioJSQ
//
//  Created by Amos Elmaliah on 4/12/16.
//  Copyright © 2016 Amos Elmaliah. All rights reserved.
//

import Foundation

extension String {
    public func nameInitials() -> String? {
        return characters.split(" ")
            .map { String($0.first!).uppercaseString  }
            .reduce("", combine: +)
    }
}
