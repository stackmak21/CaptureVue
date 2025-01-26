//
//  PopularMethodsFilterBox.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/12/24.
//

import SwiftUI


struct PopularMethodsFilterBox: View {
    var popularPaymentMethods: [PopularPaymentMethod]
    var popularCountry: String
    var popularPaymentMethodClicked: (PopularPaymentMethod) -> Void
    var showAllPaymentMethodsClicked: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let popularPaymentMethodsHeader = "POPULAR PAYMENT METHODS IN \(popularCountry.capitalized)"
            if !popularCountry.isEmpty {
                Text(popularPaymentMethodsHeader)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundColor(Color.blue) // Replace with your custom color (ButtonCyprus)
                    .padding(.bottom, 8)
            }
            Image(systemName: "wallet.bifold.fill")
            
            let methodsToShow = popularPaymentMethods.count > 4 ? popularPaymentMethods.prefix(5) : popularPaymentMethods.prefix(2)
            
            if methodsToShow.count > 3 {
                HStack(spacing: 0) {
                    
                    ForEach(Array(methodsToShow.prefix(3).enumerated()), id: \.offset) { index,method in
                        PopularPaymentMethodItem(popularPaymentMethod: method, onClick: popularPaymentMethodClicked)
                        if index < 2 {
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 0)
                Spacer()
                HStack(spacing: 0) {
                    ForEach(methodsToShow.suffix(2), id: \.self) { method in
                        PopularPaymentMethodItem(popularPaymentMethod: method, onClick: popularPaymentMethodClicked)
                        Spacer()
                    }
                    PopularPaymentMethodShowAllItem(onClick: showAllPaymentMethodsClicked)
                }
            } else {
                HStack(spacing: 0) {
                    ForEach(methodsToShow.prefix(2), id: \.self) { method in
                        PopularPaymentMethodItem(popularPaymentMethod: method, onClick: popularPaymentMethodClicked)
                        Spacer()
                    }
                    PopularPaymentMethodShowAllItem(onClick: showAllPaymentMethodsClicked)
                }
            }
        }
//        .padding(.horizontal)
    }
}

#Preview {
    PopularMethodsFilterBox(popularPaymentMethods: [
        PopularPaymentMethod( name: "PayPal", category: "digital", isSelected: false),
        PopularPaymentMethod( name: "Visa", category: "card", isSelected: false),
        PopularPaymentMethod( name: "MasterCard", category: "card", isSelected: false),
        PopularPaymentMethod( name: "Apple Pay", category: "digital", isSelected: false)
    ], popularCountry: "USA", popularPaymentMethodClicked: {_ in }, showAllPaymentMethodsClicked: {})
}


struct PopularPaymentMethodShowAllItem: View {
    var onClick: () -> Void
    
    var body: some View {
        VStack{
            Button(action: onClick) {
                VStack{
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 14)
                        .padding(12)
                        .background(Color.athensGray)
                        .clipShape(Circle())
                    
                    Text("Show All")
                        .font(.system(size: 12))
                        .foregroundColor(Color.blue)
                    Spacer()
                    
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .frame(width: 96, height: 85)
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
