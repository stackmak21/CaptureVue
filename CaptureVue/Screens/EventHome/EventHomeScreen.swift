//
//  EventHomeScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import SwiftUI
import SwiftfulRouting
import Kingfisher

struct EventHomeScreen: View {
    
    @StateObject var viewModel: EventHomeViewModel
    @State var isPresent: Bool = false
    

    init(router: AnyRouter, dataService: DataService, eventId: String ) {
        let interactor = EventHomeInteractor(dataService: dataService)
        _viewModel = StateObject(wrappedValue: EventHomeViewModel(router: router, interactor: interactor, eventId: eventId))
    }
    
    var body: some View {
        if let eventDetails = viewModel.eventDetails {
            VStack{
                ScrollView(.vertical) {
                    KFImage(URL(string: eventDetails.mainImage)!)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        
                    Text(eventDetails.eventDescription)
                    Text(eventDetails.eventName)
                    Text(eventDetails.id)
                    Text(eventDetails.mainImage)
                }
            }
        }
        
    }
}

#Preview {
    let dataService = DataServiceImpl()
    RouterView{ router in
        EventHomeScreen(router: router, dataService: dataService, eventId: "cp-12345")
    }
}
