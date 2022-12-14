//
//  ApiCardBudget.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

struct ApiCardBudget : Codable {
    let id : String
    let name : String
    let maxAmount : Double
    let amountSpent : Double
    let cardId : String
    let transactions: [ApiTransaction]?
}
