//
//  CardDetailsOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation


enum CardDetailsOutput {
    case fetchedCard(CardModel, CreditCardDataModel), fetchedTransactions([BudgetDataModel : [TransactionDataModel]]), savedTransaction(Result<Bool,Error>), userUpdated(Result<Bool,Error>)
}
