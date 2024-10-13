//
//  SplashInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation

protocol SplashInteractor{
    
}

class SplashInteractor_Production: SplashInteractor{
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
}


