//
//  Date + Extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation


extension Date {
    
    func toMonthShortFormat() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        return  dateFormatter.string(from: self)
    }
    
    func toDayShortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return  dateFormatter.string(from: self)
    }
}
