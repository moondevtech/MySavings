//
//  PaymentHistoryOutputType.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation

protocol PaymentHistoryOutputType : AnyObject {
    func handleOutput(_ output : PaymentHistoryOutput)
}
