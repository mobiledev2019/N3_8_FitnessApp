//
//  Int+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation

extension Int {
    func addComma(separatorText: String = ",") -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = separatorText
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
