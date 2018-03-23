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
    
    func calculate(offScreen: CGFloat, onScreen: CGFloat) -> CGFloat {
        return self * (offScreen - onScreen) + onScreen
    }
}

extension CGRect {
    
    init(offset: CGFloat, offScreen: CGRect, onScreen: CGRect) {
        let offsetX = offset.calculate(offScreen: offScreen.origin.x, onScreen: onScreen.origin.x)
        let offsetY = offset.calculate(offScreen: offScreen.origin.y, onScreen: onScreen.origin.y)
        let offsetWidth = offset.calculate(offScreen: offScreen.width, onScreen: onScreen.width)
        let offsetHeight = offset.calculate(offScreen: offScreen.height, onScreen: onScreen.height)
        
        self.init(x: offsetX, y: offsetY, width: offsetWidth, height: offsetHeight)
    }
}
