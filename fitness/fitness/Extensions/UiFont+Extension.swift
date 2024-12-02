//
//  UiFont+Extension.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

extension UIFont {
    enum Poppins: String {
        case medium = "Poppins-Medium"
        case regular = "Poppins-Regular"
        case semibold = "Poppins-SemiBold"
        case light = "Poppins-Light"
        case bold = "Poppins-Bold"
    }
    
    enum LeagueSpartan: String {
        case medium = "LeagueSpartan-Medium"
        case regular = "LeagueSpartan-Regular"
        case semibold = "LeagueSpartan-SemiBold"
        case light = "LeagueSpartan-Light"
        case bold = "LeagueSpartan-Bold"
    }
    
    static func poppins(_ style: Poppins, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func leagueSpartan(_ style: LeagueSpartan, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
