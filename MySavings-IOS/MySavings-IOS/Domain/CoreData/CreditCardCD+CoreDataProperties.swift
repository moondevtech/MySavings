//
//  CreditCardCD+CoreDataProperties.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//
//

import Foundation
import CoreData


extension CreditCardCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreditCardCD> {
        return NSFetchRequest<CreditCardCD>(entityName: "CreditCardCD")
    }

    @NSManaged public var accountNumber: String?
    @NSManaged public var cardHolder: String?
    @NSManaged public var cardNumber: String?
    @NSManaged public var cvv: String?
    @NSManaged public var expirationDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var budgets: NSSet?
    @NSManaged public var owner: UserCD?

}

// MARK: Generated accessors for budgets
extension CreditCardCD {

    @objc(addBudgetsObject:)
    @NSManaged public func addToBudgets(_ value: BudgetCD)

    @objc(removeBudgetsObject:)
    @NSManaged public func removeFromBudgets(_ value: BudgetCD)

    @objc(addBudgets:)
    @NSManaged public func addToBudgets(_ values: NSSet)

    @objc(removeBudgets:)
    @NSManaged public func removeFromBudgets(_ values: NSSet)

}

extension CreditCardCD : Identifiable {
    
    func toCreditCardModel() -> CreditCardDataModel{
        return CreditCardDataModel(
            cardNumber: cardNumber ?? "",
            cvv: cvv ?? "",
            expirationDate: expirationDate ?? .now,
            accountNumber: accountNumber ?? "",
            cardHolder: cardHolder ?? "",
            id: id ?? "",
            owner: owner?.toUserModel(),
            budgets: (budgets?.allObjects as? [BudgetCD])?.compactMap{ $0.toBudgetDataModel() }
        )
    }

}
