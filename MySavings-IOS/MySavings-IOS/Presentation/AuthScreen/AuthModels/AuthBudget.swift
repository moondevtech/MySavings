//
//  AuthBudget.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

struct AuthBudget : Identifiable , Hashable {
    var id : String =  UUID().description
    var title : String = "..."
    var amount : String = "\(0.0)"
    
    func realAmount() -> Double{
        Double(amount) ?? 0.0
    }
    
    func isEmpty() -> Bool{
        amount == "0.0" || title ==  "..."
    }
}
