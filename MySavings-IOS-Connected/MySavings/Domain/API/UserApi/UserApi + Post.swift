//
//  UserApi + Post.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

extension UserApi : PostApiDelegate {
    
    typealias PostResponse = PostApiResponse
    
    func post(
        _ creator : RequestCreator
    ) async throws -> Result<PostApiResponse, ApiError> {
//        var components =  URLComponents()
//        components.scheme = "http"
//        components.host = "localhost"
//        components.port = 9090
//        components.path = path
        
        var request =  URLRequest.createRequest(creator)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        

        let encoder =  JSONEncoder()
        
        if let body = creator.body{
            let data =  try encoder.encode(body)
            request.httpBody = data
        }

        
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
        Log.i(content: "post : \(statusCode)")
        switch(statusCode){
        case 300...:
            return .failure(ApiError.httpResponse(httpResponse.statusCode))
        default :
            Log.i(content: "Response : \n \(String(data: data, encoding: .utf8))")
        }
        

        let decoded = try JSONDecoder().decode(PostApiResponse.self, from: data)

        return .success(decoded)
    }
}
