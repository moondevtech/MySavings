//
//  CardSelectionInput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

enum CardSelectionInput {
    case select(Just<CardModel>), unselect(Just<CardModel>)
}
