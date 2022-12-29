//
//  PaymentHistoryInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation

enum PaymentHistoryInput {
    case fetchAllTransactions, fetch(ClosedRange<Date>)
}
