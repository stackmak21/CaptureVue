//
//  Banner.swift
//  CaptureVue
//
//  Created by Paris Makris on 9/11/24.
//

import SwiftUI
import SwiftfulRouting

struct Banner: View {
    
    let router: AnyRouter
    let message: String
    let bannerType: BannerType
    let bannerDuration: BannerDuration
    let action: BannerAction?
    
    init(
        router: AnyRouter,
        message: String,
        bannerType: BannerType,
        bannerDuration: BannerDuration,
        action: BannerAction?
    ) {
        self.router = router
        self.message = message
        self.bannerType = bannerType
        self.bannerDuration = bannerDuration
        self.action = action
        showBanner()
    }
    
    
    var body: some View {
        HStack(alignment: .center){
            Image(systemName: bannerType.icon())
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(bannerType.color())
                
            Text(message)
                .font(Typography.regular(size: 14))
                .foregroundColor(Color.white)
            if let action = action {
                Button(action: {
                    action.onTap()
                }, label: {
                    Text(action.message)
                        .font(Typography.medium(size: 16))
                        .underline(true, pattern: .solid, color: bannerType.color())
                        .foregroundColor(bannerType.color())
                        .padding(.leading, 8)
                        .multilineTextAlignment(.trailing)
                })
                
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(bannerType.color().opacity(0.05))
                
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(bannerType.color())
                .shadow(color: bannerType.color(), radius: 8, x: 0, y: 4)
        }
        
        .padding()
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + bannerDuration.duration) {
                self.router.dismissModal()
            }
        }
        .onTapGesture {
            self.router.dismissModal()
        }
    }
    
    private func showBanner() {
        router.showModal(
            transition: .move(edge: .bottom),
            animation: .easeInOut,
            alignment: .bottom,
            backgroundColor: .black.opacity(0.1),
            dismissOnBackgroundTap: true,
            ignoreSafeArea: false,
            destination: { self }
        )
    }
    
        
}

#Preview {
    RouterView{ router in
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                Banner(router: router, message: "There is an error There is an error There is an error ", bannerType: .info, bannerDuration: .short, action: BannerAction(message: "Retry", onTap: {}))
                Banner(router: router, message: "There is an error There is an error There is an error ", bannerType: .warning, bannerDuration: .short, action: BannerAction(message: "Retry", onTap: {}))
                Banner(router: router, message: "There is an error There is an error There is an error ", bannerType: .error, bannerDuration: .short, action: BannerAction(message: "Retry", onTap: {}))
            }
        }
    }
}


enum BannerType {
    case info
    case warning
    case error
    
    func color() -> Color {
        switch self {
        case .info:
            return Color.yellow
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        }
    }
    
    func icon() -> String {
        switch self {
        case .info:
            return "info.circle"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "exclamationmark.triangle"
        }
    }
}




struct BannerDuration {
    
    let duration: Double
    
    private init(duration: Double) {
        self.duration = duration
    }
    
    static var short: BannerDuration {
        BannerDuration(duration: 3.0)
    }
    
    static var long: BannerDuration {
        BannerDuration(duration: 5.0)
    }
    
    static var infinite: BannerDuration {
        BannerDuration(duration: 0.0)
    }
    
    static func custom(duration: Double) -> BannerDuration {
        return BannerDuration(duration: duration)
    }
    
}

struct BannerAction {
    let message: String
    let onTap: () -> Void
}
