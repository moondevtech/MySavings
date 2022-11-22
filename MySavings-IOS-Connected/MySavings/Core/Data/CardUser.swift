//
//  User.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import Foundation

struct CardUser : Identifiable {
    
    var id: UUID = .init()
    
    var name : String = "Jhon snow"
    
    var monthAllowedBudget : Double = 10000
    
    var cards : [CreditCardData] = CreditCardData.mock
    
}
