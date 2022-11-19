//
//  NewTransactionModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

struct NewTransactionModel {
    var budget : String = ""
    var reason : String = ""
    var amount : String = "0.0"
    var date : Date = .now
    var tabTransaction : Int = 0
    
    var realAmount : Double {
        Double(amount) ?? 0.0
    }
    
    var tabImage : String{
        tabTransaction == 0 ? "plus" : "arrow.left"
    }
    
    mutating func tabButtonNavigation(){
        if tabTransaction != 0 {
           previousTab()
        }else{
           nextTab()
        }
    }
    
    mutating func nextTab(){
        tabTransaction += 1
    }
    
    mutating func previousTab(){
        tabTransaction -= 1
    }
    
}
