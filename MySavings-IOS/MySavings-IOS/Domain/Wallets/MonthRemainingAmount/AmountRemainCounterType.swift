//
//  MonthRemainingCounterType.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation

protocol AmountRemainCounterType {
    
    associatedtype Input
    
    func calculateCurrentTransactionAmount(input : Input)
    
}
