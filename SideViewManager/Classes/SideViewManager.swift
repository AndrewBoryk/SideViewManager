//
//  SideViewManager.swift
//  Pods-SideViewManager_Example
//
//  Created by Andrew Boryk on 3/22/18.
//

import UIKit

public protocol SideViewManagerDelegate: class {
    
    /// The SideViewManager did finish moving to a given offset
    ///
    /// - Parameter offset: Offset that the SideViewManager's view has moved to (0 is off-screen, 1 is on-screen, and values can vary between these)
    func didFinishAnimating(to offset: CGFloat)
    
    /// Listen for whether a gesture in the SideViewManager has been enabled/disabled
    func didChange(gesture: UIGestureRecognizer, to isEnabled: Bool)
}

public class SideViewManager {
    
    public enum SwipeDirection {
        case horizontal
        case vertical
    }
    
    /// The controller which will have its view controlled by this manager
    private(set) public var sideController: UIViewController?
    
    /// The view which will have its v
    private(set) public var sideView: UIView?
    
    /// Direction that the manager's pan recognizer will recognize when enabled (horizontal by default)
    public var swipeDirection: SwipeDirection = .horizontal
    
    /// Delegate for the SideViewManager
    public weak var delegate: SideViewManagerDelegate?
    
    /// Frame for when the view should be off-screen, or otherwise the default position of the managed view
    public lazy var startingFrame: CGRect = {
        guard let window = window else {
            return .zero
        }
        
        let frame = window.frame
        return CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
    }()
    
    /// Frame for when the view should be on-screen, or otherwise the final "fully presented" position of the managed view
    public lazy var endingFrame: CGRect = {
        guard let window = window else {
            return .zero
        }
        
        let frame = window.frame
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }()
    
    /// Gesture for when the side view is presented, and tapping outside of the view will dismiss it
    public lazy var dismissGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        gesture.delaysTouchesBegan = false
        
        return gesture
    }()
    
    /// Gesture for swiping the side view on and off the screen
    public lazy var swipeGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.cancelsTouchesInView = false
        gesture.delaysTouchesBegan = true
        gesture.delaysTouchesEnded = false
        
        return gesture
    }()
    
    /// The view, whether it be from the sideController or sideView, that will be managed
    private var view: UIView {
        guard let view = sideController?.view else {
            guard let view = sideView else {
                fatalError("SideViewManager needs to be initialized with a sideController or sideView that is non-null")
            }
            
            return view
        }
        
        return view
    }
    
    /// The starting origin value for the side view when the pan gesture begins
    private var panStartLocation: CGFloat = 0
    
    /// The last velocity of the pan gesture, where after beginning, will be anything other than 0
    private var panLastVelocity: CGPoint = .zero
    
    /// Easily accessible application's keyWindow
    private var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    /// Returns the current offset of the side view
    private var currentOffset: CGFloat {
        let onOrigin = endingFrame.origin
        let offOrigin = startingFrame.origin
        let sideOrigin = view.frame.origin
        switch swipeDirection {
        case .horizontal where isOppositeDirection:
            return (onOrigin.x - sideOrigin.x) / (onOrigin.x - offOrigin.x)
        case .horizontal:
            return (offOrigin.x - sideOrigin.x) / (offOrigin.x - onOrigin.x)
        case .vertical where isOppositeDirection:
            return (onOrigin.y - sideOrigin.y) / (onOrigin.y - offOrigin.y)
        case .vertical:
            return (offOrigin.y - sideOrigin.y) / (offOrigin.y - onOrigin.y)
        }
    }

    /// Returns whether the startingFrame origin is less than the endingFrame origin
    private var isOppositeDirection: Bool {
        let isHorizontalOpposite = swipeDirection == .horizontal && startingFrame.origin.x < endingFrame.origin.x
        let isVerticalOpposite = swipeDirection == .vertical && startingFrame.origin.y < endingFrame.origin.y
        return isHorizontalOpposite || isVerticalOpposite
    }
    
    // MARK: - Initializer
    /// Initialize a `SideViewManager` with a sideController to manage its view, and customizable on-screen and off-screen frames
    ///
    /// - Parameters:
    ///   - sideController: The controller that will have its view managed by the manager
    ///   - startingFrame: The frame that the sideController's view should be at when off-screen, or otherwise at its default state
    ///   - endingFrame: The frame that the sideController's view should be at when on-screen, or otherwise at its full-presented state
    public init(controller: UIViewController, startingFrame: CGRect? = nil, endingFrame: CGRect? = nil) {
        sideController = controller
        update(startingFrame: startingFrame, endingFrame: endingFrame)
    }
    
    /// Initialize a `SideViewManager` with a view to manage, and customizable on-screen and off-screen frames
    ///
    /// - Parameters:
    ///   - view: View which will be managed
    ///   - startingFrame: The frame that the sideController's view should be at when off-screen, or otherwise at its default state
    ///   - endingFrame: The frame that the sideController's view should be at when on-screen, or otherwise at its full-presented state
    public init(view: UIView, startingFrame: CGRect? = nil, endingFrame: CGRect? = nil) {
        sideView = view
        update(startingFrame: startingFrame, endingFrame: endingFrame)
    }
    
    // MARK: - Public
    /// Toggle swipe to dismiss/present the sideController's view
    public func setSwipeGesture(isEnabled: Bool) {
        set(gesture: swipeGesture, isEnabled: isEnabled)
    }
    
    /// Toggle tap-away to dismiss the sideController's view
    public func setDismissGesture(isEnabled: Bool) {
        set(gesture: dismissGesture, isEnabled: isEnabled)
    }
    
    /// Set the sideController's view to a specific offset (0 being fully off-screen and 1 being fully on-screen), at a given animation duration, which is defaulted to 0.25 seconds
    public func move(to offset: CGFloat, duration: TimeInterval = 0.25) {
        let clampedOffset = offset.clamped(min: 0, max: 1)
        let newOffset = isOppositeDirection ? clampedOffset : 1 - clampedOffset
        let newFrame = CGRect(offset: newOffset, starting: startingFrame, ending: endingFrame)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = newFrame
        }) { _ in
            self.delegate?.didFinishAnimating(to: offset)
        }
    }
    
    /// Present the sideController's view, which means to move it to its `endingFrame` value, at a given animation duration, which is defaulted to 0.25 seconds
    public func present(animationDuration: TimeInterval = 0.25) {
        move(to: 1, duration: animationDuration)
    }
    
    /// Dismiss the sideController's view, which means to move it to its `startingFrame` value, at a given animation duration, which is defaulted to 0.25 seconds
    public func dismiss(animationDuration: TimeInterval = 0.25) {
        move(to: 0, duration: animationDuration)
    }
    
    // MARK: - Private
    /// Sets the given gesture to enabled/disabled, and adds/removes from the window when needed
    private func set(gesture: UIGestureRecognizer, isEnabled: Bool) {
        let contains = window?.gestureRecognizers?.contains(gesture) ?? false
        
        if !contains && isEnabled {
            window?.addGestureRecognizer(gesture)
        } else if contains && !isEnabled {
            window?.removeGestureRecognizer(gesture)
        }
        
        delegate?.didChange(gesture: gesture, to: isEnabled)
    }
    
    /// Handles the tap gesture for the `dismissGesture`
    @objc private func dismiss(_ recognizer: UITapGestureRecognizer) {
        guard currentOffset == 1 else {
            return
        }
        
        let sideFrame = view.frame
        let loc = recognizer.location(in: view)
        if loc.x < 0 || loc.x > sideFrame.width {
            move(to: 0)
        } else if loc.y < 0 || loc.y > sideFrame.height {
            move(to: 0)
        }
    }
    
    /// Handles the pan gesture for the `swipeGesture` (couldn't resist the naming)
    @objc private func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard let window = window else {
            return
        }
        
        
        switch recognizer.state {
        case .began:
            panLastVelocity = .zero
            
            let origin = view.frame.origin
            let constainsView = window.subviews.contains(view)
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
            
            let isHorizontal = swipeDirection == .horizontal
            let maxOffset = isHorizontal ? window.frame.width : window.frame.height
            let rTranslation = recognizer.translation(in: window)
            let translation = panStartLocation + (isHorizontal ? rTranslation.x : rTranslation.y)
            let comparisonOffset = isHorizontal ? endingFrame.width : endingFrame.height
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
    
    /// Updates the startingFrame and endingFrame if non-nil, shared in the initializers and not to be used elsewhere
    private func update(startingFrame: CGRect? = nil, endingFrame: CGRect? = nil) {
        if let endingFrame = startingFrame {
            self.startingFrame = endingFrame
        }
        
        if let endingFrame = endingFrame {
            self.endingFrame = endingFrame
        }
        
        guard let window = window else {
            return
        }
        
        if !window.subviews.contains(view) {
            view.frame = self.startingFrame
            view.setShadow()
            
            window.addSubview(view)
        }
    }
    
    deinit {
        view.removeFromSuperview()
    }
}



