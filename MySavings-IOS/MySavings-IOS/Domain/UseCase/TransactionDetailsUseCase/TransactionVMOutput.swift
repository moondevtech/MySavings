//
//  TransactionVMOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

enum TransactionVMOutput {
    case started(TransactionScreenModel), remove(Result<(Bool, TransactionDataModel), Error>), userUpdated(Result<Bool,Error>)
}
