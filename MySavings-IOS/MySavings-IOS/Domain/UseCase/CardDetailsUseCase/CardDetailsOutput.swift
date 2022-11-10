//
//  CardDetailsOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation


enum CardDetailsOutput {
    case fetchedCard(CardModel), fetchedTransactions(TransactionData)
}
