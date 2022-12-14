//
//  ApiCreditCard.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

struct ApiCreditCard : Codable {
    var id: UUID = .init()
    var accountNumber : String = "19 747 838404"
    var cardHolder : String = "Jhon snow"
    var cardNumber : String = "4234  4526  3674  2727"
    var cvv : String = "939"
    var cardType : String = "MasterCard"
    var bankName : String = "Hapoalim"
    var expirationDate : Date =  .now
    var budgets : [ApiCardBudget] = []
}
