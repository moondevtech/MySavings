//
//  AuthViewModelOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation


enum AuthViewModelOutput {
    case register(Result<PersistingUser,AuthError>), login(Result<PersistingUser,AuthError>)
}
