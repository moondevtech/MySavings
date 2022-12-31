//
//  OtpOutput.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation


enum OtpError {
    case wrongType
}

enum OtpOutput {
    case digitAdded(DigitModel), animatedOut(Int), removeDigit([DigitModel]), error(OtpError)
}
