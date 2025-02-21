//
//  HomeResponse.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct HomeResponse {
    let customer: Customer
    let hostEvents: [Event]
    let participatingEvents: [Event]
    
    init(
        customer: Customer = Customer(),
        hostEvents: [Event] = [],
        participatingEvents: [Event] = []
    ) {
        self.customer = customer
        self.hostEvents = hostEvents
        self.participatingEvents = participatingEvents
    }
}
