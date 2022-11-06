//
//  AuthUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation


class AuthUseCase {
    
    var userRepository : UserRepositoryDelegate
    weak var delegate : AuthUseCaseDelegate?
    
    init(_ userRepository: UserRepositoryDelegate,
         delegate: AuthUseCaseDelegate? = nil) {
        self.userRepository = userRepository
        self.delegate = delegate
    }
    
    func register(authUser : AuthUser){
        guard authUser.isValid else {
            delegate?.handleResult(result: .register(.failure(.wrongCredentials)))
            return
        }
        
        do{
            let model = UserDataModel(password: authUser.password, username: authUser.name)
           try userRepository.create(model)
            delegate?.handleResult(result: .register(.success(model)))
        }catch{
            delegate?.handleResult(result: .register(.failure(.domain(error))))
        }
    }
    
}
