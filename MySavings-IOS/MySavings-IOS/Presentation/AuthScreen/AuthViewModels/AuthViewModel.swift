//
//  AuthViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine

typealias RegistrationResult = Result<UserDataModel,AuthError>

class AuthViewModel : ObservableObject {
    
    @Published var userDataModel : UserDataModel = .init(password: "", username: "")
    var authError = PassthroughSubject<AuthError,Never>()
    var isRegistered = PassthroughSubject<Bool,Never>()
    
    //TabView Bug
    var showTab = PassthroughSubject<Int,Never>()

    var userRepository : UserRepositoryDelegate
    lazy var useCase : AuthUseCase = AuthUseCase(userRepository, delegate: self)
    
    init(userRepository: UserRepositoryDelegate =  UserRepository(dataSource: UserLocalDataSource())) {
        self.userRepository = userRepository
    }
    
    private func onRegistered(_ registrationResult : RegistrationResult){
        switch registrationResult {
        case .success(let result):
            isRegistered.send(true)
            self.userDataModel = result
        case .failure(let failure):
            //handle error
            authError.send(.wrongCredentials)
            Log.e(error: failure)
            
        }
    }
    
}

extension AuthViewModel : AuthViewModelType {
    
    func handleInput(authInput: AuthViewModelInput) {
        switch authInput {
        case .register(let authUser):
            useCase.register(authUser: authUser)
        }
    }

}

extension AuthViewModel : AuthUseCaseDelegate {
    func handleResult(result: AuthViewModelOutput) {
        switch result {
        case .register(let result):
            onRegistered(result)
        }
    }
}
