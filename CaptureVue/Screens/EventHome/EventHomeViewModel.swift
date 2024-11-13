//
//  EventHomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import Foundation
import SwiftfulRouting
import SwiftUI
import Combine

@MainActor
class EventHomeViewModel: ObservableObject {
    
    private let router: AnyRouter
    private let interactor: EventHomeInteractor
    private var tasks: [Task<Void, Error>] = []
    private var cancellables: Set<AnyCancellable> = []
    private let eventId: String
    
    @Published var eventDetails: EventDto?

    init(
        router: AnyRouter,
        interactor: EventHomeInteractor,
        eventId: String
    ) {
        self.router = router
        self.interactor = interactor
        self.eventId = eventId
        fetchEventDetails(eventId: eventId)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }


  
    
    private func fetchEventDetails(eventId: String){
        let task = Task{
            do{
                eventDetails = try await interactor.fetchEventDetails(eventId: eventId)
            }
            catch let error as CaptureVueErrorDto {
                print(error)
            }
        }
        tasks.append(task)
    }
    
}





