//
//  Double + extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation


extension Double {
    
    enum Formatting {
        case currency , percent
        
        var endfix : String {
            switch self {
                
            case .currency:
                return "₪"
            case .percent:
                return "%"
            }
        }
    }
    
    func formatted(formatting : Formatting) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return "\(numberFormatter.string(from: NSNumber(value: self))!) \(formatting.endfix)"
    }
    
    func formatted() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    func isPositive() -> Bool{
        return self > 0
    }
}
