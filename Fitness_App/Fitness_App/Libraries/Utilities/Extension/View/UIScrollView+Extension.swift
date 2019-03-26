//
//  UIScrollView+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToVeryBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + 85)
        if bottomOffset.y > contentOffset.y {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}
