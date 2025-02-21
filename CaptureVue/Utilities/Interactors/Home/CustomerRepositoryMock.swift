//
//  CustomerRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct CustomerRepositoryMock: CustomerRepositoryContract {
    func fetchHomeContract(_ token: String) async -> Result<HomeResponse, CaptureVueError> {
        let event = DeveloperPreview.instance.event
        return .success(HomeResponse(customer: event.creator, hostEvents: [event], participatingEvents: [event]))
    }
    
}
