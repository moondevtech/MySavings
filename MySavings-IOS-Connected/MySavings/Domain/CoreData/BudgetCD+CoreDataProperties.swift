//
//  BudgetCD+CoreDataProperties.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//
//

import Foundation
import CoreData


extension BudgetCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetCD> {
        return NSFetchRequest<BudgetCD>(entityName: "BudgetCD")
    }

    @NSManaged public var amountSpent: Double
    @NSManaged public var id: String?
    @NSManaged public var maxAmount: Double
    @NSManaged public var name: String?
    @NSManaged public var fromCard: CreditCardCD?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension BudgetCD {
    
    var unwrappedTransactions : [TransactionsCD] {
        transactions?.allObjects as? [TransactionsCD] ?? []
    }

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionsCD)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionsCD)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension BudgetCD : Identifiable {
    
    func toBudgetDataModel() -> BudgetDataModel{
        return BudgetDataModel(
            id: id ?? "",
            name: name ?? "",
            amountSpent: amountSpent ,
            maxAmount: maxAmount,
            transactions : (transactions?.allObjects as? [TransactionsCD])?.map{ $0.toTransactionDataModel() }
        )
    }

}
