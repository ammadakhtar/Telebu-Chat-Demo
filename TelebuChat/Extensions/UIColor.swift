//
//  UIColor.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import Foundation
import UIKit

extension UIColor {
    
    class func CustomColorFromHexaWithAlpha (_ hex:String, alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in:(CharacterSet.whitespacesAndNewlines as CharacterSet) as CharacterSet).uppercased()
        
        if cString.hasPrefix("#") {
            let start = cString.index(cString.startIndex, offsetBy: 1)
            let end = cString.index(before: cString.endIndex)
            cString = String(cString[start..<end])
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
