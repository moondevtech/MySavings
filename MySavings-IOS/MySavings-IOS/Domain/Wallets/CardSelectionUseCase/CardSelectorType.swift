//
//  CardSelectorType.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation

protocol CardSelectorType {
    
    associatedtype Card
    
    func selectCard(input : CardSelectionInput)
    
}
