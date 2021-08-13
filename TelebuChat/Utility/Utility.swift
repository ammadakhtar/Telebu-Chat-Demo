//
//  Utility.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit

class Utility: NSObject {
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
