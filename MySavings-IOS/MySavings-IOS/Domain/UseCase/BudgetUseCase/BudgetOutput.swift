//
//  BudgetOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

enum BudgetOutput {
    case budgetFetched(Double, Double), percentCalculated(Double),  displayToggled(BudgetDisplayType)
}
