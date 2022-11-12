//
//  CardListVMInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

enum CardManagementInput {
    case fetchCards, selectCard(CardModel), showCardHolder(CardModel), deleteCard(String)
}
