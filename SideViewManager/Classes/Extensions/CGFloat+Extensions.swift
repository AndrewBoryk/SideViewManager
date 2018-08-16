//
//  CGFloat+Extensions.swift
//  Pods-SideViewManager_Example
//
//  Created by Andrew Boryk on 3/22/18.
//

import UIKit

extension CGFloat {
    
    func clamped(min: CGFloat, max: CGFloat) -> CGFloat {
        return self < min ? min : (self > max ? max : self)
    }
    
    func calculate(starting: CGFloat, ending: CGFloat) -> CGFloat {
        return self * (starting - ending) + ending
    }
}

extension CGRect {
    
    init(offset: CGFloat, starting: CGRect, ending: CGRect) {
        let offsetX = offset.calculate(starting: starting.origin.x, ending: ending.origin.x)
        let offsetY = offset.calculate(starting: starting.origin.y, ending: ending.origin.y)
        let offsetWidth = offset.calculate(starting: starting.width, ending: ending.width)
        let offsetHeight = offset.calculate(starting: starting.height, ending: ending.height)
        
        self.init(x: offsetX, y: offsetY, width: offsetWidth, height: offsetHeight)
    }
}
