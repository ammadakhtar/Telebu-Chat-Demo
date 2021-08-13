//
//  UIView.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit

enum Direction: Int {
    case topToBottom = 0
    case bottomToTop
    case leftToRight
    case rightToLeft
}

enum RoundEdges {
    case topLeft
    case topRight
    case bottomLeft
    case BottomRight
    case allEdges
}

enum ShadowDirections {
    case topToLeft
    case topToRight
    case leftTobottom
    case rightToBottom
    case all
}

extension UIView {
    @IBInspectable
    var isCirculer: Bool {
        
        get {
            return layer.cornerRadius == min(self.frame.width, self.frame.height) / CGFloat(2.0) ? true : false
        }
        
        set {
            
            if newValue {
                layer.cornerRadius = self.frame.height/2
                self.clipsToBounds = true
                
            } else {
                layer.cornerRadius = 0.0
                self.clipsToBounds = false
            }
        }
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom, halfHeight: Bool = false) {
        var height: CGFloat = self.bounds.height
        if halfHeight {
            height = self.bounds.height / 2
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: height)
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addDropShadowToRoundedCorners(cornerShadowPath: UIRectCorner, edges: [RoundEdges], radius: CGFloat = 30, shadowDirection: ShadowDirections = .topToLeft, offset : Int = 2, shadowOpacity : Float = 1.0, shadowRadius : CGFloat = 2.0) {
        
        // Get rounded corners
        var maskedCorners: CACornerMask = CACornerMask()
        
        for corner in edges {
            
            switch corner {
                
            case .topLeft:
                maskedCorners.insert(.layerMinXMinYCorner)
                break
                
            case .topRight:
                maskedCorners.insert(.layerMaxXMinYCorner)
                break
                
            case .bottomLeft:
                maskedCorners.insert(.layerMinXMaxYCorner)
                break
                
            case .BottomRight:
                maskedCorners.insert(.layerMaxXMaxYCorner)
                break
                
            case .allEdges:
                maskedCorners.insert(.layerMinXMinYCorner)
                maskedCorners.insert(.layerMaxXMinYCorner)
                maskedCorners.insert(.layerMinXMaxYCorner)
                maskedCorners.insert(.layerMaxXMaxYCorner)
                break
            }
        }
        
        //get shadowDirections
        var shadowOffset : CGSize?
        
        switch shadowDirection {
            
        case .topToLeft:
            shadowOffset = CGSize(width: -offset, height: -offset)
            break
            
        case .topToRight:
            shadowOffset = CGSize(width: offset, height: -offset)
            break
            
        case .leftTobottom:
            shadowOffset = CGSize(width: -offset, height: offset)
            break
            
        case .rightToBottom:
            shadowOffset = CGSize(width: offset, height: offset)
            break
            
        case .all:
            shadowOffset = CGSize(width: 0, height: 0)
            break
        }
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerShadowPath, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        // For sharp edges, try to keep shadow rdaius less than offset
        self.layer.shadowColor = UIColor.CustomColorFromHexaWithAlpha("1C202E", alpha: 0.2).cgColor
        self.layer.shadowPath = shadowLayer.path
        self.layer.shadowOffset = shadowOffset!
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = maskedCorners
    }
}
