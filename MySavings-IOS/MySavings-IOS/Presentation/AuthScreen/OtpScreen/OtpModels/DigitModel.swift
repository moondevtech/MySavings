//
//  DigitModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation

struct DigitModel : Identifiable, Equatable {
    var id : UUID = .init()
    var x : CGFloat = 300
    var value : String
}

