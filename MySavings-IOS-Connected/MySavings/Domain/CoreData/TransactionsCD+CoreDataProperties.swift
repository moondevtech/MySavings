//
//  TransactionsCD+CoreDataProperties.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//
//

import Foundation
import CoreData


extension TransactionsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionsCD> {
        return NSFetchRequest<TransactionsCD>(entityName: "TransactionsCD")
    }

    @NSManaged public var amount: Double
    @NSManaged public var transactionDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var transactionTitle: String?
    @NSManaged public var budget: BudgetCD?

}

extension TransactionsCD : Identifiable {
    
    func toTransactionDataModel() -> TransactionDataModel {
        TransactionDataModel(id: id!, amount: amount, transactionDate: transactionDate!, transactionTitle: transactionTitle!)
    }

}
