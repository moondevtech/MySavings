//
//  CardListVMOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

typealias SuccessError = Result<(Bool, String) ,Error>

enum CardManagementOutput {
    case fetchCard(CardFetched), updateCards([CardModel]) ,selectedCard(CardHolder), cardsDeleted(SuccessError)
}
