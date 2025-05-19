//
//  SettingsViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/5/25.
//

import Foundation
import SwiftfulRouting



@MainActor
class SettingsViewModel: BaseViewModel {
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    
    private let updateUsernameUseCase: UpdateUsernameUseCase
    private let keychain: KeychainManager = KeychainManager()
    
    @Published var isLoading: Bool = false
    
    @Published var isUsernameSheetPresented: Bool = false
    @Published var username: String = ""
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        authRepositoryMock: AuthRepositoryMock? = nil
        //        eventRepositoryMock: EventRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.updateUsernameUseCase = UpdateUsernameUseCase(client: client, authRepositoryMock: authRepositoryMock)
        //        self.createEventUseCase = CreateEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func onUsernameSubmit(username: String){
        let task = Task{
            setLoading()
            defer { resetLoading() }
            let response = await updateUsernameUseCase.invoke(username)
            switch response {
            case .success(let updateUsernameResponse):
                keychain.saveData(updateUsernameResponse.guestCustomer, key: .customer)
                isUsernameSheetPresented = false
            case .failure(let error):
                Banner(message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        tasks.append(task)
    }
    
    
    
}


//MARK: - Navigation
extension SettingsViewModel{
    
    func goBack() {
        router.dismissScreen()
    }
}
