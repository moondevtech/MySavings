//
//  BudgetUseCaseDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

protocol BudgetUseCaseDelegate : AnyObject {
    func handleOutput( _ output : BudgetOutput)
}
