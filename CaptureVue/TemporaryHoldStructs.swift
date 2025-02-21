//
//  TemporaryHoldStructs.swift
//  CaptureVue
//
//  Created by Paris Makris on 7/2/25.
//

import SwiftUI

struct GeometryGetter: View {
    let coordinateSpace: CoordinateSpace
    let action: (CGRect) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Text("")
                .onChange(of: geometry.frame(in: coordinateSpace)) { rect in
                    action(rect)
                }
        }
    }
}


extension View {
    func frameReader(coordinateSpace: CoordinateSpace = .global, perform action: @escaping (CGRect) -> Void) -> some View {
        self.background(GeometryGetter(coordinateSpace: coordinateSpace, action: action))
    }
}


extension NSObject {
    func accessibilityDescendant(passing test: (Any) -> Bool) -> Any? {
        
        if test(self) { return self }
        
        for child in accessibilityElements ?? [] {
            if test(child) { return child }
            if let child = child as? NSObject, let answer = child.accessibilityDescendant(passing: test) {
                return answer
            }
        }
        
        for subview in (self as? UIView)?.subviews ?? [] {
            if test(subview) { return subview }
            if let answer = subview.accessibilityDescendant(passing: test) {
                return answer
            }
        }
        
        return nil
    }
}

extension NSObject {
    func accessibilityDescendant(identifiedAs id: String) -> Any? {
        return accessibilityDescendant {
            // For reasons unknown, I cannot cast a UIView to a UIAccessibilityIdentification at runtime.
            return ($0 as? UIView)?.accessibilityIdentifier == id
            || ($0 as? UIAccessibilityIdentification)?.accessibilityIdentifier == id
        }
    }
    
    func buttonAccessibilityDescendant() -> Any? {
        return accessibilityDescendant { ($0 as? NSObject)?.accessibilityTraits == .button }
    }
}


extension View{
    func triggerDatePickerPopover(pickerId: String) {
        if
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first,
            let picker = window.accessibilityDescendant(identifiedAs: pickerId) as? NSObject,
            let button = picker.buttonAccessibilityDescendant() as? NSObject
        {
            button.accessibilityActivate()
        }
    }
}
