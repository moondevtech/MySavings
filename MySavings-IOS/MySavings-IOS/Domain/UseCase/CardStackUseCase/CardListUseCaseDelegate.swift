//
//  CardListUseCaseDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

protocol CardListUseCaseDelegate : AnyObject {
    func handleOuput(_ output : CardListVMOutput)
}
