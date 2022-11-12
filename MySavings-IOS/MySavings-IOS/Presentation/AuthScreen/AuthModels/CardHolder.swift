//
//  CardHolder.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation


struct CardHolder : Identifiable, Equatable {
    
    var id =  UUID().uuidString
    var cardnumber : String = "5402278662861637"
    var cardholder : String = ""
    var cvv : String = ""
    var expirationDate : Date = .now
    var cardType : CardType = .Unknown

    var isValid : Bool = false
    var isReady : Bool {
        isValid && !cvv.isEmpty && !cardholder.isEmpty
    }
}

//https://www.vccgenerator.org/result/
//
//BRAND : MASTERCARD
//        NUMBER : 5402278662861637
//        BANK : BANK OF JERUSALEM, LTD.
//        NAME : Gloriana berg
//        ADDRESS : Via Silvio Spaventa 148
//        COUNTRY : ISRAEL
//        MONEY : $647
//        CVV/CVV2 : 491
//        EXPIRY : 04/2026
//        PIN : 2367
