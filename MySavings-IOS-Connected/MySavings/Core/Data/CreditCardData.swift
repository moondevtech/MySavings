//
//  CreditCardData.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import Foundation

struct CreditCardData : Identifiable , Hashable {
    
    static func == (lhs: CreditCardData, rhs: CreditCardData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    var id: UUID = .init()
    
    var name : String = "Jhon snow"
    
    var cardNumber : String = "4234  4526  3674  2727"
    
    var accountNumber : String = "19 747 838404"
    
    var expired : Date =  .now
    
    var cvv : String = "939"
    
    var bank : String = "Hapoalim"
    
    var type : String = "MasterCard"
    
    var transaction : [TransactionData] = TransactionData.getMock()
    
    var r : Double = .random(in: 0...1)
    var g : Double = .random(in: 0...1)
    var b : Double = .random(in: 0...1)

    
    static var mock : [Self] = [
        CreditCardData(name: "Pikachu", cardNumber: "4234  4526  3584  2924"),
        CreditCardData(name: "Francis Lalane", cardNumber: "4234  9382  3584  2726"),
        CreditCardData(name: "Malcolm x", cardNumber: "4234  4526  2934  2792")
//        CreditCardData(name: "Raichu", cardNumber: "4234  1234  3584  2924"),
//        CreditCardData(name: "Francis Cabrel", cardNumber: "1234  9382  3584  2726"),
//        CreditCardData(name: "Malcolm Y", cardNumber: "4234  4526  2934  1234")
    ]
    
}
