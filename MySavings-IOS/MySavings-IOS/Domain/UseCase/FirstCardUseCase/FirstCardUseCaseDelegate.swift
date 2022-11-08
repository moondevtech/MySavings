//
//  FirstCardUseCaseDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 08/11/2022.
//

import Foundation

protocol FirstCardUseCaseDelegate : AnyObject {
    
    func handleOutput(_ output : FirstCardOutput)
    
}
