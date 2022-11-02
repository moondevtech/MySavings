//
//  Color + Extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import Foundation
import SwiftUI

extension Color {
    
    static func creditCardColor(_ creditCardData : CreditCardData) -> Self{
        Color(red:creditCardData.r, green: creditCardData.g, blue: creditCardData.b, opacity: 1)
    }
}
