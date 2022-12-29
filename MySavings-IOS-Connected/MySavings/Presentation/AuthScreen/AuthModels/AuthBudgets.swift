//
//  AuthBudgets.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

struct AuthBudgets : Identifiable {
    
    var id : String =  UUID().description
    var budgets : [AuthBudget] = .init()
    var tempBudgets : [AuthBudget] = .init()

    
    var savable : Bool {
        tempBudgets.count > 0 &&
        tempBudgets.map{$0.isEmpty()}.contains{$0 == false}
    }
    
}
