//
//  Float+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
extension Float {
    func roundSuffix(_ numberOfPlaces: Int) -> Float {
        let numberOfPlaces = Float(numberOfPlaces)
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = roundf(self * multiplier) / multiplier
        return rounded
    }
}
