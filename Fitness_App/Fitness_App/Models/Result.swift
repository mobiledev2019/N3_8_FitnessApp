//
//  File.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/23/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
class Result {
  //  var id: int?
    var date: String?
    var complete: Double?
    init(date: String, complete: Double?) {
        self.date = date
        self.complete = complete
    }
    init() {
         
    }
}
