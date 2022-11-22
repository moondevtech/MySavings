//
//  TransactionScreenViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation
import Combine

class TransactionScreenViewModel : ObservableObject {
    
    private lazy var useCase : TransactionDetailsUseCase = .init(delegate : self)
    
    var screenModelReceived : PassthroughSubject<TransactionScreenModel,Never> = .init()
    var removedScreenModel : PassthroughSubject<TransactionScreenModel,Never> = .init()

    
    
    private func handleReceivedScreenModel(_ model : TransactionScreenModel){
        screenModelReceived.send(model)
    }
    
    private func handleRemovedTransaction(_ result : Result<(Bool, TransactionDataModel), Error>){
        switch result {
        case .success(let success):
            if success.0 {
                handleInput(.updateUser)
                removedScreenModel.send(TransactionScreenModel(transaction: success.1))
            }else{
                Log.i(content: "Could not remove \(success.1)")
            }
        case .failure(let failure):
            Log.e(error: failure)
        }
    }
    
    private func handleUserUpdate(_ result : Result<Bool, Error>){
        switch result {
        case .success(_):
            Log.s(content: "User updated !")
        case .failure(let failure):
            Log.e(error: failure)
        }
    }
    
}

extension TransactionScreenViewModel : TransactionInputType {
    
    func handleInput(_ input: TransactionVMInput) {
        switch input {
        case .start(let transactionDataModels):
            useCase.start(with: transactionDataModels)
        case .remove(let dataModel):
            useCase.removeTransaction(dataModel.transaction)
        case .updateUser:
            useCase.updateUser()
        }
    }
    
}

extension TransactionScreenViewModel : TransactionOutputType {
    
    func handleOutput(_ output : TransactionVMOutput){
        switch output {
        case .remove(let result):
            handleRemovedTransaction(result)
        case .userUpdated(let result):
            handleUserUpdate(result)
        case .started(let transactionScreenModel):
            handleReceivedScreenModel(transactionScreenModel)
        }
    }
}
