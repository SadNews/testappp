//
//  UIView+Extension.swift
//  fitness
//
//  Created by Andrey Ushakov on 03.12.2024.
//

import UIKit

public extension UIView {
    @discardableResult
    func prepareForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func pinEdgesToSuperviewEdges(withOffset offset: CGFloat) {
        pinEdgesToSuperviewEdges(
            top: offset,
            left: offset,
            bottom: offset,
            right: offset
        )
    }
    
    func pinEdgesToSuperviewEdges(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        leadingAnchor ~= superview.leadingAnchor + left
        trailingAnchor ~= superview.trailingAnchor - right
        topAnchor ~= superview.topAnchor + top
        bottomAnchor ~= superview.bottomAnchor - bottom
    }
    
    func pinToCenterSuperview(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        centerXAnchor ~= superview.centerXAnchor + xOffset
        centerYAnchor ~= superview.centerYAnchor + yOffset
    }
    
    func pinToCenterXSuperview(xOffset: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        centerXAnchor ~= superview.centerXAnchor + xOffset
    }
    
    func pinToCenterYSuperview(yOffset: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        centerYAnchor ~= superview.centerYAnchor + yOffset
    }
    
    enum PinnedSide {
        case top
        case left
        case right
        case bottom
    }
    
    func pinEdgesToSuperviewEdges(excluding side: PinnedSide) {
        switch side {
        case .top:
            pinToSuperview([.left, .right, .bottom])
        case .left:
            pinToSuperview([.top, .right, .bottom])
        case .right:
            pinToSuperview([.top, .left, .bottom])
        case .bottom:
            pinToSuperview([.top, .left, .right])
        }
    }
    
    func pinToSuperview(_ sides: [PinnedSide]) {
        guard let superview = superview, !sides.isEmpty else {
            fatalError("There is no superview or sides")
        }
        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= superview.topAnchor
            case .right:
                trailingAnchor ~= superview.trailingAnchor
            case .left:
                leadingAnchor ~= superview.leadingAnchor
            case .bottom:
                bottomAnchor ~= superview.bottomAnchor
            }
        }
    }
    
    func pin(
        to view: UIView,
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) {
        pin(to: view, edgesInsets: UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        ))
    }
    
    func pin(to view: UIView, edgesInsets: UIEdgeInsets) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        topAnchor ~= view.topAnchor + edgesInsets.top
        trailingAnchor ~= view.trailingAnchor - edgesInsets.right
        leadingAnchor ~= view.leadingAnchor + edgesInsets.left
        bottomAnchor ~= view.bottomAnchor - edgesInsets.bottom
    }
    
    func pin(as view: UIView, using sides: [PinnedSide]) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= view.topAnchor
            case .right:
                trailingAnchor ~= view.trailingAnchor
            case .left:
                leadingAnchor ~= view.leadingAnchor
            case .bottom:
                bottomAnchor ~= view.bottomAnchor
            }
        }
    }
    
    func equalSides(size: CGFloat) {
        heightAnchor ~= size
        widthAnchor ~= size
    }
}

public struct ConstraintAttribute<T: AnyObject> {
    let anchor: NSLayoutAnchor<T>
    let const: CGFloat
}

public struct LayoutGuideAttribute {
    let guide: UILayoutSupport
    let const: CGFloat
}

public struct MultiplierAttribute {
    let anchor: NSLayoutDimension
    let multiplier: CGFloat
}

public func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

public func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

public func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

public func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

public func * (lhs: NSLayoutDimension, rhs: CGFloat) -> MultiplierAttribute {
    return MultiplierAttribute(anchor: lhs, multiplier: rhs)
}

// ~= is used instead of == because Swift can't overload == for NSObject subclass
@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: MultiplierAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}
