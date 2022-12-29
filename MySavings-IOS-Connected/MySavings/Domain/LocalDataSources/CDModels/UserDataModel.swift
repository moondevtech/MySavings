//
//  UserDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import CoreData

struct UserDataModel : DataSourceModelDelegate {
    var id : String = UUID().uuidString
    var password : String
    var registrationDate : Date = .now
    var username : String
    var cards : [CreditCardDataModel] = []
}

