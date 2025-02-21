//
//  CustomerRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

protocol CustomerRepositoryContract {
    func fetchHomeContract(_ token: String) async -> Result<HomeResponse, CaptureVueError>

}
