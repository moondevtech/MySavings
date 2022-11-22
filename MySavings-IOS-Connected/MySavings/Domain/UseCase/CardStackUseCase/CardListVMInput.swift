//
//  CardListVMInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

enum CardListVMInput {
    case fetchCards, toCardDetails(CardModel), selectCard(CardModel), newBudget(NewBudgetModel), updateUser
}
