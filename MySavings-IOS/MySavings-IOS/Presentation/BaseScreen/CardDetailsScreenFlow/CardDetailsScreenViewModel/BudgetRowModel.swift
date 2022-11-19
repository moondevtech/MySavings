//
//  BudgetRowModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

struct BudgetRowModel: Identifiable, Hashable, Equatable {
    var id : String =  UUID().uuidString
    var budgetDataModel : BudgetDataModel
    var isSelected : Bool = false
    var offset : CGFloat = -600
}
