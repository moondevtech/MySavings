//
//  ExpensesTransactionInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 20/11/2022.
//

import Foundation

enum ExpensesTransactionInput {
    
   case fetch([CardModel]), filter(([CardModel],String))
    
}
