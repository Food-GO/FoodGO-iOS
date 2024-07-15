//
//  UIFont+Ext.swift
//  YoriJori
//
//  Created by 김강현 on 7/15/24.
//

import UIKit

extension UIFont {
    enum Pretendard {
        
        case black
        case regular
        case semiBold
        case bold
        case light
        case extraBold
        case medium
        
        var value: String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .medium:
                return "Pretendard-Medium"
            }
        }
    }
    
    static func pretendard(_ type: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: type.value, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
