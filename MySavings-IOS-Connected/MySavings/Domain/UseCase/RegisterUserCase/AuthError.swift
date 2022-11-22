//
//  AuthError.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

enum AuthError : LocalizedError{
    case none, wrongCredentials, domain(Error)
}
