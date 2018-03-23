//
//  UIView+Autolayout.swift
//  Pods-SideViewManager_Example
//
//  Created by Andrew Boryk on 3/22/18.
//

import Foundation

extension UIView {
     
    /// Pins the edges of the view to another view, with a constant value of 0 on all constraints.
    ///
    /// - Parameters:
    ///   - view: View to pin edges to
    public func pinEdges(to view: UIView) {
        setConstraint(.leading, constant: 0, toView: view)
        setConstraint(.top, constant: 0, toView: view)
        view.setConstraint(.trailing, constant: 0, toView: self)
        view.setConstraint(.bottom, constant: 0, toView: self)
    }
    
    /// Sets a constraint to the view using the given constraint kind, and can take a constant value for the constraint, as well as another view to constrain to for constraint kinds other than height or width.
    ///
    /// - Parameters:
    ///   - kind: Kind of constraint to be applied to the view
    ///   - constant: The constant value to be used for the constraint
    ///   - view: View that the constraint will be applied to (Not necessary for height and width)
    public func setConstraint(_ kind: NSLayoutAttribute, constant: CGFloat = 0, toView view: UIView) {
        guard let newConstraint = constraint(for: kind, toView: view, constant: constant) else {
            return
        }
        
        newConstraint.isActive = true
    }
    
    /// Calls the addConstraint function for multiple kinds of constraints.
    ///
    /// - Parameters:
    ///   - kinds: Kind of constraint to be applied to the view
    ///   - constant: The constant value to be used for the constraint
    ///   - view: View that the constraint will be applied to (Not necessary for height and width)
    public func setConstraints(_ kinds: [NSLayoutAttribute], constant: CGFloat = 0, toView view: UIView) {
        _ = kinds.map { setConstraint($0, constant: constant, toView: view) }
    }
    
    private func constraint(for kind: NSLayoutAttribute, toView view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint? {
        
        switch kind {
        case .bottom:
            return bottomAnchor.constraint(equalTo: view!.bottomAnchor, constant: constant)
        case .top:
            return topAnchor.constraint(equalTo: view!.topAnchor, constant: constant)
        case .leading:
            return leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: constant)
        case .trailing:
            return trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: constant)
        default:
            return nil
        }
    }
}
