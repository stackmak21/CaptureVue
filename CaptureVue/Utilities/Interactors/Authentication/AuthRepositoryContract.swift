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



//MARK: - Contract

protocol AuthRepositoryContract {
    func login(_ credentials: Credentials) async -> Result<LoginResponse, CaptureVueError>
    func guestLogin() async -> Result<LoginResponse, CaptureVueError>
    func register(_ registerDetails: RegisterDetails) async -> Result<RegisterResponse, CaptureVueError>
    
}
