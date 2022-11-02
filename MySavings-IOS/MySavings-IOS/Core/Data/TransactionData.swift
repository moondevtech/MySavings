//
//  TransactionData.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation

struct TransactionData : Identifiable, Hashable{
    
    var id : UUID = UUID()
    
    var date : Date = .now
    
    var reason : String = ""
    
    var amount : Double = 0.0
    
    var dayDateString : String {
        return date.toDayShortFormat()
    }
    
    var monthDateString : String {
        return date.toMonthShortFormat()
    }
    
    private static let calendar =  Calendar.current

    
    static func getMock() -> [Self] {
        let all = [
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 20), to: .now)!, reason: "Buy socks", amount: 12.90),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 18), to: .now)!,reason: "Eat a sandwich", amount: 3.40),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 15), to: .now)!,reason: "Watched a movie", amount: 5.80),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 14), to: .now)!,reason: "Had a drink", amount: 10.90),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 12), to: .now)!,reason: "week end food", amount: 30.45),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 10), to: .now)!,reason: "phone bill", amount: 50.70),
            TransactionData(date: calendar.date(byAdding: .day, value: -Int.random(max: 2), to: .now)!,reason: "rent", amount: 200.0),
        ]
        
        let randomMax =  Int.random(max: all.count)
        let range = (0..<randomMax)
        let transactions = Array(all[range])

        return transactions
    }
}

extension Int {
    static func random(max : Int) -> Self{
        return Int.random(in: 0...max)
    }
}
