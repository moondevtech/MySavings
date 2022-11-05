//
//  CardDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation

struct CreditCardDataModel : DataSourceModelDelegate{
    
    var cardNumber: String
    var cvv: String
    var expirationDate: Date
    var accountNumber: String
    var cardHolder: String
    var id: String
    var owner: UserDataModel?
    var budgets : [BudgetDataModel]?

}

