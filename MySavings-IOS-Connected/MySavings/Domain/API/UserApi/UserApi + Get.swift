//
//  UserApi + Get.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

extension UserApi : GetApiDelegate {
    typealias GetResponse = ApiUser
        
    func get(
        _ creator : RequestCreator
    ) async throws -> Result<GetResponse, ApiError> {
        //http://localhost:9090/register/user
        
        var request =  URLRequest.createRequest(creator)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        switch(httpResponse.statusCode){
        case 300...:
            return .failure(ApiError.httpResponse(httpResponse.statusCode))
        default :
            Log.s(content: "Content Received \(String(data: data, encoding: .utf8) ?? "No data")")
        }
        
        let decoded = try JSONDecoder().decode(GetResponse.self, from: data)

        return .success(decoded)
    }
       
}
