//
//  Typography.swift
//  CaptureVue
//
//  Created by Paris Makris on 9/10/24.
//

import Foundation
import UIKit
import SwiftUI

struct Typography {
    static func light(size: CGFloat) -> Font {
        FontFamily.Ubuntu.light.font(size: size)
    }
    static func regular(size: CGFloat) -> Font {
        FontFamily.Ubuntu.regular.font(size: size)
    }
    static func medium(size: CGFloat) -> Font {
        FontFamily.Ubuntu.medium.font(size: size)
    }
    static func bold(size: CGFloat) -> Font {
        FontFamily.Ubuntu.bold.font(size: size)
    }
}


typealias SwiftUiFont = Font
typealias UiKitFont = UIFont

extension FontConvertible {
    func font(size: CGFloat) -> SwiftUiFont {
        return SwiftUiFont.custom(name, size: size)
    }
    
    func uiKitFont(size: CGFloat) -> UiKitFont {
        return font(size: size)
    }
}
