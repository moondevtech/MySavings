//
//  AuthUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine


class AuthUseCase {
    
    var userRepository : UserRepositoryDelegate
    private var subscriptions : Set<AnyCancellable> = .init()
    weak var delegate : AuthUseCaseDelegate?
    
    init(_ userRepository: UserRepositoryDelegate,
         delegate: AuthUseCaseDelegate? = nil) {
        self.userRepository = userRepository
        self.delegate = delegate
    }
    
    
    func login(){
        do{
            try userRepository.fetch()
                .first()
                .map{
                    PersistingUser(userDataModel: $0.toUserModel(), userCd: $0)
                }
                .sink(receiveValue: { [weak self] userDataModel in
                    self?.delegate?.handleResult(result: .login(.success(userDataModel)))
                })
                .store(in: &subscriptions)
        }catch{
            Log.e(error: error)
            delegate?.handleResult(result: .login(.failure(.domain(error))))
        }
    }
    
    func register(authUser : AuthUser){
        guard authUser.isValid else {
            delegate?.handleResult(result: .register(.failure(.wrongCredentials)))
            return
        }
        
        do{
            let model = UserDataModel(password: authUser.password, username: authUser.name)
           try userRepository.create(model)
           try userRepository.fetch(with: model.id)
                .sink(receiveValue: {[weak self] userCd in
                    self?.delegate?.handleResult(result: .register(.success(PersistingUser(userDataModel: model, userCd: userCd))))
                })
                .store(in: &subscriptions)
        }catch{
            delegate?.handleResult(result: .register(.failure(.domain(error))))
        }
    }
    
}
