//
//  URLComponent + Extension.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

struct RequestCreator{
    var path : String
    var scheme : String
    var host : String?
    var port : Int?
    var body : Encodable?
    var queryParams : [String : Any]?
    
    var queryItems: [URLQueryItem]?  {
        return queryParams?.map({ item in
            URLQueryItem(name: item.key, value: "\(item.value)")
        })
    }
}

extension URLRequest{
 
    static func createRequest(_ creator : RequestCreator) -> URLRequest {
        var components =  URLComponents()
        components.scheme = creator.scheme
        components.host = creator.host
        components.port = creator.port
        components.path = creator.path
        components.queryItems =  creator.queryItems
        var request =  URLRequest(url: components.url!)
        return request
    }
}
