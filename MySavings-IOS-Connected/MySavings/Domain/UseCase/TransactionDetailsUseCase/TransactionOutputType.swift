//
//  TransactionOutputType.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

protocol TransactionOutputType : AnyObject {
    func handleOutput(_ output : TransactionVMOutput)
}
