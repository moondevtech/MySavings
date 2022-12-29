//
//  CardDetailsOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation


enum CardDetailsOutput {
    case fetchedCard(CardModel, CreditCardDataModel)
    case fetchedTransactions([BudgetDataModel : [TransactionDataModel]])
    case savedTransaction(Result<Bool,Error>)
    case userUpdated(Result<Bool,Error>)
}
