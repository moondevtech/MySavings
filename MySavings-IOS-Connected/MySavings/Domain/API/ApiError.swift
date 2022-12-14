//
//  ApiError.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

enum ApiError : LocalizedError {
    case httpResponse(Int), error(String)
}
