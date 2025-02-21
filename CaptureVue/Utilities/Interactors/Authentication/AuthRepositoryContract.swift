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

typealias LoginResponseDtoResult = Result<LoginResponseDto, CaptureVueErrorDto>
typealias LoginResponseResult = Result<LoginResponse, CaptureVueError>

//MARK: - Contract

protocol AuthRepositoryContract {
    func login(_ credentials: Credentials) async -> LoginResponseResult

}
