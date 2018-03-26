//
//  SideViewManager.swift
//  Pods-SideViewManager_Example
//
//  Created by Andrew Boryk on 3/22/18.
//

import UIKit

public protocol SideViewManagerDelegate: class {
    
    func didFinishAnimating(to offset: CGFloat)
    func didChange(gesture: UIGestureRecognizer, to isEnabled: Bool)
}

public class SideViewManager {
    
    public enum SwipeDirection {
        case horizontal
        case vertical
    }
    
    public let sideController: UIViewController
    public var swipeDirection: SwipeDirection = .horizontal
    public weak var delegate: SideViewManagerDelegate?
    
    public lazy var offScreenFrame: CGRect = {
        guard let window = window else {
            return .zero
        }
        
        let frame = window.frame
        return CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
    }()
    
    public lazy var onScreenFrame: CGRect = {
        guard let window = window else {
            return .zero
        }
        
        let frame = window.frame
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }()
    
    public lazy var dismissGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        gesture.delaysTouchesBegan = false
        
        return gesture
    }()
    
    public lazy var swipeGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.cancelsTouchesInView = false
        gesture.delaysTouchesBegan = true
        gesture.delaysTouchesEnded = false
        
        return gesture
    }()
    
    private var panStartLocation: CGFloat = 0
    private var panLastVelocity: CGPoint = .zero
    
    private var sideWidth: CGFloat {
        return onScreenFrame.width
    }
    
    private var sideHeight: CGFloat {
        return onScreenFrame.height
    }
    
    private var sideOffsetY: CGFloat {
        return onScreenFrame.origin.y
    }
    
    private var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    private var currentOffset: CGFloat {
        guard let sideView = sideController.view else {
            return 0
        }
        
        switch swipeDirection {
        case .horizontal:
            return (offScreenFrame.origin.x - sideView.frame.origin.x) / (offScreenFrame.origin.x - onScreenFrame.origin.x)
        case .vertical:
            return (offScreenFrame.origin.y - sideView.frame.origin.y) / (offScreenFrame.origin.y - onScreenFrame.origin.y)
        }
    }
    
    public init(sideController: UIViewController) {
        self.sideController = sideController
        
        guard let window = window, let sideView = sideController.view else {
            return
        }
        
        if !window.subviews.contains(sideView) {
            sideView.frame = offScreenFrame
            sideView.setShadow()
            
            window.addSubview(sideView)
        }
    }
    
    public func setSwipeGesture(isEnabled: Bool) {
        set(gesture: swipeGesture, isEnabled: isEnabled)
    }
    
    public func setDismissGesture(isEnabled: Bool) {
        set(gesture: dismissGesture, isEnabled: isEnabled)
    }
    
    private func set(gesture: UIGestureRecognizer, isEnabled: Bool) {
        let contains = window?.gestureRecognizers?.contains(gesture) ?? false
        
        if !contains && isEnabled {
            window?.addGestureRecognizer(gesture)
        } else if contains && !isEnabled {
            window?.removeGestureRecognizer(gesture)
        }
        
        delegate?.didChange(gesture: gesture, to: isEnabled)
    }
    
    public func move(to offset: CGFloat, duration: TimeInterval = 0.25) {
        guard let sideView = sideController.view else {
            return
        }
        
        let newOffset = 1 - offset.clamped(min: 0, max: 1)
        let newFrame = CGRect(offset: newOffset, offScreen: offScreenFrame, onScreen: onScreenFrame)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            sideView.frame = newFrame
        }) { _ in
            self.delegate?.didFinishAnimating(to: offset)
        }
    }
    
    @objc private func dismiss(_ recognizer: UITapGestureRecognizer) {
        guard let sideView = sideController.view, currentOffset == 1 else {
            return
        }
        
        let sideFrame = sideView.frame
        let loc = recognizer.location(in: sideView)
        if loc.x < 0 || loc.x > sideFrame.width {
            move(to: 0)
        } else if loc.y < 0 || loc.y > sideFrame.height {
            move(to: 0)
        }
    }
    
    @objc private func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard let window = window else {
            return
        }
        
        
        switch recognizer.state {
        case .began:
            panLastVelocity = .zero
            
            let origin = sideController.view.frame.origin
            let constainsView = window.subviews.contains(sideController.view)
            switch swipeDirection {
            case .horizontal:
                panStartLocation = constainsView ? origin.x : window.frame.width
            case .vertical:
                panStartLocation = constainsView ? origin.y : window.frame.height
            }
        case .changed:
            let velocity = recognizer.velocity(in: window)
            switch swipeDirection {
            case .horizontal where velocity.x != 0,
                 .vertical where velocity.y != 0:
                panLastVelocity = velocity
            default:
                break
            }
            
            let maxOffset = window.frame.width
            let isHorizontal = swipeDirection == .horizontal
            let rTranslation = recognizer.translation(in: window)
            let translation = panStartLocation + (isHorizontal ? rTranslation.x : rTranslation.y)
            let comparisonOffset = isHorizontal ? sideWidth : sideHeight
            let panTranslation = translation.clamped(min: maxOffset - comparisonOffset, max: maxOffset)
            let offset = (maxOffset - panTranslation) / comparisonOffset
            move(to: offset, duration: 0)
        case .ended:
            let velocity = swipeDirection == .horizontal ? panLastVelocity.x : panLastVelocity.y
            let shouldDismissOffset: CGFloat = (currentOffset < (velocity > 1000 ? 0.9 : 0.6)) ? 0 : 1
            let shouldPresentOffset: CGFloat = (currentOffset > 0.25 || velocity < -1000) ? 1 : 0
            move(to: velocity > 0 ? shouldDismissOffset : shouldPresentOffset)
        default:
            break;
        }
    }
}



