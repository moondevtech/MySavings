//
//  ExpenseGraphModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import Foundation
import SwiftUI
import Charts

struct ExpenseGraphModel : Identifiable{
    
    var id : UUID = UUID()
    
    var transaction : TransactionData
    var cardColor : Color
    var cardNumber : String
    
    var secretCardNumber : String {
        let lastNumbers =  Array(cardNumber.split(separator: " ")).last!
        return "**** \(lastNumbers)"
    }
}
