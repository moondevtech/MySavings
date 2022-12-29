//
//  SelectedCardContent.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 20/11/2022.
//

import Foundation

struct SelectedCardContent : Identifiable {
    var id : UUID = .init()
    var cardModels : [CardModel]
}
