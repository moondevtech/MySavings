//
//  AuthUseCasDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation

protocol AuthUseCaseDelegate : AnyObject {
    func handleResult(result : AuthViewModelOutput)
}
