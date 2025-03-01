//
//  AuthRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//


//
//  LoginInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation



//MARK: - Type Alias

typealias LoginResponseDtoResult = Result<LoginResponseDto, CaptureVueResponseRaw>
typealias LoginResponseResult = Result<LoginResponse, CaptureVueResponseRaw>

//MARK: - Contract

protocol AuthRepositoryContract {
    func login(_ credentials: Credentials) async -> LoginResponseResult

}
