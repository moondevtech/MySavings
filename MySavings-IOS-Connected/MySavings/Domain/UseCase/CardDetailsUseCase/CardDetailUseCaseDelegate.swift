//
//  CardDetailUseCaseDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation

protocol CardDetailUseCaseDelegate : AnyObject{
    func handleOutput(_ output : CardDetailsOutput)
}
