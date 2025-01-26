//
//  TestView.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/11/24.
//

import SwiftUI
import AVKit

struct TestView: View {
    @State var isPlaying: Bool = false
    @State var player: AVPlayer? = {
        return .init(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!)
    }()
    
    let onClick: () -> Void
    
    var body: some View {
        VStack{
            
            StatusPageSection(
                title: "Reason",
                content: "fdsgdfsg gfgf  gfdgdf gdfg dfg fd gfd gdf gdf g df fgdsgdfsgs ggfsdgdsgs gsgsdgds gsdg dsg sgds gds gds gds gds gds gds g sdg dsg sdg sd gds gsd g sdg ds gsd g",
                onRetryClicked:  nil
            )
            Divider()
            StatusPageSection(
                title: "Reason",
                content: "fdsgdfsg gfgf  gfdgdf gdfg dfg fd gfd gdf gdf g df fgdsgdfsgs ggfsdgdsgs gsgsdgds gsdg dsg sgds gds gds gds gds gds gds g sdg dsg sdg sd gds gsd g sdg ds gsd g",
                onRetryClicked:  onClick
            )
            
            TransactionStatusLabel()
                .padding()
            
            PopularMethodsFilterBox(popularPaymentMethods: [PopularPaymentMethod(name: "PayPal1", category: "digital", isSelected: true),PopularPaymentMethod(name: "PayPal2", category: "digital", isSelected: true),PopularPaymentMethod(name: "PayPal3", category: "digital", isSelected: true),PopularPaymentMethod(name: "PayPal4", category: "digital", isSelected: true),PopularPaymentMethod(name: "PayPal5", category: "digital", isSelected: true)], popularCountry: "", popularPaymentMethodClicked: {method in }, showAllPaymentMethodsClicked: {})
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .padding()
            PaymentMethodFilterItem(onRemovePaymentMethodClick: {fdfd in })
            
            PaymentMethodFilterClearItem(onPaymentMethodsFilterClearAllClick: {})
            
            HStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        PaymentMethodFilterItem(onRemovePaymentMethodClick: {fdfd in })
                        PaymentMethodFilterItem(onRemovePaymentMethodClick: {fdfd in })
                        PaymentMethodFilterItem(onRemovePaymentMethodClick: {fdfd in })
                        PaymentMethodFilterClearItem(onPaymentMethodsFilterClearAllClick: {})
                    }
                    .padding()
                    
                }
            }
            .background(Color.athensGray)
        }
    }
    
    enum PaymentMethodCategory: String {
        case bankTransfers = "bank-transfers"
        case cash = "cash"
        case debitCreditCards = "debit-credit-cards"
        case digitalWallets = "digital-wallets"
        case giftCards = "gift-cards"
        case mobileMoney = "mobile-money"
        case remittanceServices = "remittance-services"
    }

    private func getPaymentMethodIcon (category: String) -> Image {
        Image(uiImage: Asset.story1.image)
    }
}

#Preview {
    ZStack{
        Color.white.ignoresSafeArea()
        TestView(onClick: {})
    }
}

struct PaymentMethodFilterItem: View {
    
    let onRemovePaymentMethodClick: (PaymentMethod) -> Void
    var body: some View {
        HStack(spacing: 12){
            Text("Western Union")
                .font(Typography.medium(size: 12))
            Button(action: {}) {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(Color.black)
                    .scaledToFit()
                    .frame(width: 8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        
        .background(Color.white)
        
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}

struct PaymentMethod {
    let myVar: String
}


struct PaymentMethodFilterClearItem: View {
    
    let onPaymentMethodsFilterClearAllClick: () -> Void
    
    var body: some View {
        VStack{
            Button(action: {onPaymentMethodsFilterClearAllClick()}) {
                HStack(spacing: 6){
                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundColor(Color.black)
                        .scaledToFit()
                        .frame(width: 10)
                    Text("Clear All")
                        .font(Typography.medium(size: 12))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct TransactionStatusLabel: View{
    var body: some View{
        HStack{
            Circle()
                .foregroundColor(Color.red) // Change Color function
                .frame(width: 8, height: 8)
            Text("Error") // Change Text function
                .foregroundColor(Color.black) // Change Color Definition
                .font(Typography.medium(size: 12))
        }
        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
        .background(Color.white) // Change Color Alabaster_Alabaster
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.18), radius: 3, x: 0, y: 2) // cyprusSteady
    }
}


struct StatusPageSection: View {
    
    let title: String
    let content: String
    let onRetryClicked: (() -> Void)?
    
    var body: some View {
        VStack{
            HStack{
                Text("fdf dfdf dsf sdfd gdf gfdsfsdfdsfdfdsfdsfdsfdsfddsfdsfsdfdsfsdfdfsdfsd fsdfdsfdfsdfdsfdsfsdfdsfsdf222321325454")
                    .font(Typography.medium(size: 14))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .foregroundColor(.red)
            }
            Text(title)
                .font(Typography.medium(size: 12))
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            Text(content)
                .font(Typography.medium(size: 12))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let callback = onRetryClicked {
                Button {
                    callback()
                } label: {
                    Text("Retry")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
