//
//  CardDetailsInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation

enum CardDetailsInput {
    case fetchCard(String), fetchTransaction(CreditCardDataModel), saveTransaction(NewTransactionModel), updateUser
}
