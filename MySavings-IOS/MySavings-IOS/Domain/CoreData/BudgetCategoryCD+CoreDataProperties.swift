//
//  BudgetCategoryCD+CoreDataProperties.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//
//

import Foundation
import CoreData


extension BudgetCategoryCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCategoryCD> {
        return NSFetchRequest<BudgetCategoryCD>(entityName: "BudgetCategoryCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension BudgetCategoryCD : Identifiable {

}
