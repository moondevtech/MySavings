//
//  CardHolder.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation


struct CardHolder : Identifiable, Equatable {
    
    var id =  UUID().uuidString
    var cardnumber : String = ""
    var cardholder : String = ""
    var cvv : String = ""
    var expirationDate : Date = .now
    var accountNumber : Date = .now
}
