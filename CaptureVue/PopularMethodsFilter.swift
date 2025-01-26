//
//  PopularMethodsFilterBox.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/12/24.
//

import SwiftUI

struct PopularPaymentMethodItem: View {
    var popularPaymentMethod: PopularPaymentMethod
    let onClick: (PopularPaymentMethod) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: getPaymentMethodIcon(popularPaymentMethod.category)) // Replace with your actual icon fetching logic
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(Color.black.opacity(0.87))
            
            Spacer()
            
            Text(popularPaymentMethod.name)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black.opacity(0.87))
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .frame(width: 96, height: 85)
        .background(popularPaymentMethod.isSelected ? Color.athensGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        
        .onTapGesture {
            onClick(popularPaymentMethod)
        }
    }
}

// Usage example:
struct ContentView: View {
    var body: some View {
        PopularPaymentMethodItem(
            popularPaymentMethod: PopularPaymentMethod(name: "PayPal", category: "digital", isSelected: true)
        ) { method in
            print("Selected: \(method.name)")
        }
    }
}

// Model (Replace with your actual model):
struct PopularPaymentMethod: Hashable {
    let name: String
    let category: String
    var isSelected: Bool
}

// Utility Function (Replace with your actual logic):
func getPaymentMethodIcon(_ category: String) -> String {
    switch category {
    case "digital":
        return "creditcard" // Replace with the correct icon name
    default:
        return "questionmark"
    }
}

// Extensions for Colors (Optional if you're using custom colors):
extension Color {
    static let athensGray = Color.gray.opacity(0.2) // Replace with your actual AthensGray color
}

#Preview {
    PopularPaymentMethodItem(popularPaymentMethod: PopularPaymentMethod(name: "PayPal", category: "digital", isSelected: true), onClick: {_ in })
}

