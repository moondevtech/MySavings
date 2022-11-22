//
//  AuthUser.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

struct AuthUser {
    var name : String = ""
    var password : String = ""
    
    var isValid : Bool {
        name.count > 3 && password.count > 3
    }
}
