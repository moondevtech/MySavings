//
//  Double + extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation


extension Double {
    
    func formatted() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    func isPositive() -> Bool{
        return self > 0
    }
}
