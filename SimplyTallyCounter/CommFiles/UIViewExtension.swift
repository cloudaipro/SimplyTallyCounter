//
//  UIView.swift
//  HHMobile
//
//  Created by Shih-Kung Chen on 2019-06-13.
//  Copyright © 2019 CCS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }

    func addSubviewEqualSize(_ subview: UIView){
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    func addSubviewAtCenter(_ subview: UIView, _width: CGFloat = 0, _height: CGFloat = 0){
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        self.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
        if _width > 0 {
            subview.widthAnchor.constraint(equalToConstant: _width).isActive = true
        }
        if _height > 0 {
            subview.heightAnchor.constraint(equalToConstant: _height).isActive = true
        }
    }
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    func top(constant: CGFloat) {
        setConstraint(value: constant, attribute: .top)
    }
    func bottom(constant: CGFloat) {
        setConstraint(value: constant, attribute: .bottom)
    }
    func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: nil,
                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }

    func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute, toItem: Any?, toItemAttribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: toItem,
                               attribute: toItemAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }

    func addShadow(shadowColor: CGColor = UIColor.label.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0,
                   shadowPath: CGPath? = nil
    ) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
        if let path = shadowPath {
            self.layer.shadowPath = path
        }
        
    }
    enum AIEdge:Int {
        case
        Top,
        Left,
        Bottom,
        Right,
        Top_Left,
        Top_Right,
        Bottom_Left,
        Bottom_Right,
        All,
        None
    }
    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, shadowRadius: CGFloat, edge:AIEdge, shadowSpace:CGFloat, cornerRadius: CGFloat? = nil)    {

            var sizeOffset:CGSize = CGSize.zero
            switch edge {
            case .Top:
                sizeOffset = CGSize(width: 0, height: -shadowSpace)
            case .Left:
                sizeOffset = CGSize(width: -shadowSpace, height: 0)
            case .Bottom:
                sizeOffset = CGSize(width: 0, height: shadowSpace)
            case .Right:
                sizeOffset = CGSize(width: shadowSpace, height: 0)


            case .Top_Left:
                sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
            case .Top_Right:
                sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
            case .Bottom_Left:
                sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
            case .Bottom_Right:
                sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)


            case .All:
                sizeOffset = CGSize(width: 0, height: 0)
            case .None:
                sizeOffset = CGSize.zero
            }

            self.layer.cornerRadius = cornerRadius ?? self.frame.size.height / 2
            self.layer.masksToBounds = true;

            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = sizeOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false

            self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        }
    
    func addDashedBorder(borderColor: UIColor, cornerRadius: CGFloat, lineWidth: CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
