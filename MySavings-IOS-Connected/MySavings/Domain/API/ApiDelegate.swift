//
//  ApiDelegate.swift
//  MySavings
//
//  Created by Ruben Mimoun on 13/12/2022.
//

import Foundation
import Combine


protocol GetApiDelegate {
    
    associatedtype GetResponse : Codable
    
    func get(
        _ creator : RequestCreator
    ) async throws -> Result<GetResponse, ApiError>
    
}

protocol PostApiDelegate {
    
    associatedtype PostResponse : Codable
    
    func post(
        _ creator : RequestCreator
    ) async throws -> Result<PostResponse, ApiError>
    
}
