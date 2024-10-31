//
//  OnBoardingInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation

protocol OnBoardingInteractor{
    
}


class OnBoardingInteractor_Production: OnBoardingInteractor{
    let dataService: NetworkService
    
    init(dataService: NetworkService) {
        self.dataService = dataService
    }
}
