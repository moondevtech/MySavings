//
//  CardModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation


struct CardModel  : Identifiable, Hashable{
    
    var id: String = UUID().uuidString
    
    var updater : Bool = false
    
    var isSelected : Bool = false
    
    
    var cardData : CreditCardData{
        didSet{
            updater.toggle()
        }
    }
    
    var cardNumber : String {
        cardData.cardNumber
    }
    
    var accountNumber : String{
        cardData.accountNumber
    }
    
    var cvv : String {
        cardData.cvv
    }
    
    var date : String {
        return cardData.expired.toMonthShortFormat()
    }
    
    var name : String {
        cardData.name
    }
    
    var secretCardNumber : String {
        let lastNumbers =  Array(cardNumber.split(separator: " ")).last!
        return "**** \(lastNumbers)"
    }
    
}
