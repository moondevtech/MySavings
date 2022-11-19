//
//  TransactionVMInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

enum TransactionVMInput {
    case start([TransactionDataModel]), remove(TransactionScreenModel), updateUser
}
