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
    
    @Published var event: EventDto
    
    init(
        router: AnyRouter,
        interactor: EventHomeInteractor,
        event: EventDto
    ) {
        self.router = router
        self.interactor = interactor
        self.event = event
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }

    
}





