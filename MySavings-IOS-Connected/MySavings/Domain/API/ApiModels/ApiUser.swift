//
//  ApiUser.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

struct ApiUser : Codable {
    
    var id: String
    var email : String
    var phoneNumber : String
    var firstname : String
    var lastname : String
    var dateOfBirth : Double
    var registrationDate: Double
    var password: String
    var creditCards: [ApiCreditCard]?
    
}
