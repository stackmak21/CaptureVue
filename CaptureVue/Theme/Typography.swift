//
//  Typography.swift
//  CaptureVue
//
//  Created by Paris Makris on 9/10/24.
//

import Foundation
import SwiftUI

struct Typography {
    static func light(size: CGFloat) -> Font {
        FontFamily.Ubuntu.light.swiftUIFont(size: size)
    }
    static func regular(size: CGFloat) -> Font {
        FontFamily.Ubuntu.regular.swiftUIFont(size: size)
    }
    static func medium(size: CGFloat) -> Font {
        FontFamily.Ubuntu.medium.swiftUIFont(size: size)
    }
    static func bold(size: CGFloat) -> Font {
        FontFamily.Ubuntu.bold.swiftUIFont(size: size)
    }
}
