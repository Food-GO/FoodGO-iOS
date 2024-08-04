//
//  UIFont+Ext.swift
//  YoriJori
//
//  Created by 김강현 on 7/15/24.
//

import UIKit

extension UIFont {
    enum SUIT {
        
        case extraBold
        case bold
        case semiBold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .extraBold:
                return "SUIT-ExtraBold"
            case .bold:
                return "SUIT-Bold"
            case .semiBold:
                return "SUIT-SemiBold"
            case .medium:
                return "SUIT-Medium"
            case .regular:
                return "SUIT-Regular"
            }
        }
    }
    
    static func suit(_ type: SUIT, size: CGFloat) -> UIFont {
        return UIFont(name: type.value, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
