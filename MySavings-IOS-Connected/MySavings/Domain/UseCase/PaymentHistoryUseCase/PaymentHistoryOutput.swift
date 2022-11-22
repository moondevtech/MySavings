//
//  PaymentHistoryOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation

enum PaymentHistoryOutput {
    case fetchedTransaction(HistoryTransactionModel), filtered([HistoryTransactionModel])
}

