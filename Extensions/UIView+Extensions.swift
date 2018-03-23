//
//  UIView+Extensions.swift
//  Pods-SideViewManager_Example
//
//  Created by Andrew Boryk on 3/22/18.
//

import UIKit

extension UIView {
    
    func setShadow(offset: CGSize = .zero, radius: CGFloat = 2, opacity: Float = 0.25) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
