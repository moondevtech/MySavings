//
//  BudgetCategoryDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

struct BudgetCategoryDataModel : DataSourceModelDelegate{
    
    var id: String =  UUID().uuidString
    var categoryName : String
    var createdAt : Date
}
