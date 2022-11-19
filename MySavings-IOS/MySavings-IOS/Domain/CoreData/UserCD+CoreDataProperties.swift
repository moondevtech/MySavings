//
//  UserCD+CoreDataProperties.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var registrationDate: Date?
    @NSManaged public var username: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension UserCD {
    
    var unwrappedCards : [CreditCardCD] {
        cards?.allObjects as? [CreditCardCD] ?? []
    }

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CreditCardCD)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CreditCardCD)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

extension UserCD : Identifiable {
    
    
    func toUserModel() -> UserDataModel{
        
        let userCards = cards?.allObjects.map{$0 as! CreditCardCD}.map{$0.toCreditCardModel()} ?? []
        
       return UserDataModel(
           id:  id ?? "",
           password: password ?? "",
           registrationDate: registrationDate ?? .now,
           username : username ?? "",
           cards: userCards
       )
   }
}
