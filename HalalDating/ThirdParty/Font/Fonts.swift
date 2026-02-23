//
//  Fonts.swift
//  HalalDating
//
//  Created by Apple on 24/09/24.
//

import Foundation
enum Fonts: String {

    case SFproSemiBold = "SFProText-Semibold"
    case SFProBold = "SFProText-Bold"
    case SFProRegular = "SFProText-Regular"
    
    case oldStandardRegular = "OldStandard-Regular"
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            assertionFailure("Font not loaded.")
            return .systemFont(ofSize: size)
        }
        return font
    }
}
