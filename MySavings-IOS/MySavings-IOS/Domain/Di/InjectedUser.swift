//
//  InjectedUser.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine

struct PersistingUser {
    
    var userDataModel : UserDataModel
    var userCd : UserCD?
}

struct InjectedUser  {
    
    fileprivate static var current : Self = .init()
    
    private init(){}
    
    var userDataModel : DynamicReference<PersistingUser> = .init(value: PersistingUser(userDataModel: .init(password: "", username: ""), userCd: nil))
    
}

@propertyWrapper
struct CurrentUser {
    
    var isMock : Bool = false
    
    init(isMock: Bool = false) {
        self.isMock = isMock
        if isMock{
            wrappedValue = DynamicReference(
                value: PersistingUser(userDataModel: UserDataModel(
                    password: "123456",
                    username: "Ruben",
                    cards: .init(arrayLiteral:
                            .init(
                                cardNumber: "5402279427154581",
                                cvv: "521",
                                expirationDate: .distantFuture,
                                accountNumber: "",
                                cardHolder: "Tavana Alba",
                                id: "112345665",
                                type: "Mastercard",
                                budgets : .init(arrayLiteral:
                                        .init(id: UUID().uuidString, name: "Food", amountSpent: 100, maxAmount: 300),
                                        .init(id: UUID().uuidString, name: "School", amountSpent: 200, maxAmount: 1000)
                                )),
                                 
                        .init(
                            cardNumber: "4557435297200252",
                            cvv: "114",
                            expirationDate: .distantFuture,
                            accountNumber: "",
                            cardHolder: " Kesirat Zotova",
                            id: "112345666",
                            type: "Visa",
                            budgets : .init(arrayLiteral:
                                    .init(id: UUID().uuidString, name: "Food", amountSpent: 300, maxAmount: 400),
                                    .init(id: UUID().uuidString, name: "Sport", amountSpent: 200, maxAmount: 500)
                            )
                        ),
                                 
                        .init(
                            cardNumber: "370946596894259",
                            cvv: "3292",
                            expirationDate: .distantFuture,
                            accountNumber: "",
                            cardHolder: "Patrick Abitbol",
                            id: "112345667",
                            type: "Visa",
                            budgets : .init(arrayLiteral:
                                    .init(id: UUID().uuidString, name: "School", amountSpent: 100, maxAmount: 300),
                                    .init(id: UUID().uuidString, name: "Games", amountSpent: 200, maxAmount: 700)
                            )
                        )
                    )
                ))
                
            )
        }
    }
    
    var wrappedValue: DynamicReference<PersistingUser> {
        get {
            InjectedUser.current.userDataModel
        }
        
        set{
            InjectedUser.current.userDataModel = newValue
        }
    }
    
    var projectedValue : AnyPublisher<PersistingUser,Never>{
        Just(wrappedValue.value)
            .eraseToAnyPublisher()
    }
    
}
