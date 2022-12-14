//
//  TestRequests.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

func testPostApi(){
    let userApi =  UserApi()
    let user =  ApiUser(
        id: "toDelete",
        email: "jo@gmail.com",
        phoneNumber : "9720502894293",
        firstname: "JhonnyPost",
        lastname: "Card",
        dateOfBirth: 0,
        registrationDate: 0,
        password: "123456",
        creditCards: []
    )
    
    let requestCreator = RequestCreator(
        path: UserApiPath.register.rawValue,
        scheme: "http",
        host: "localhost",
        port: 9090,
        body: user
    )
    
    Task{
        do{
            let result = try await userApi.post(requestCreator)
            switch (result){
            case .failure(let error):
                Log.e(error: error)
            case .success(let data):
                Log.s(content: "ApiSuccess \n \(data)")
            }

        }catch{
            Log.e(error: error)
        }
    }

}

func testGetUserWithCredentialsApi(){
    let userApi =  UserApi()
    let queryParams : [String : Any] = [
        "password" : "123456",
        "email" : "jo@gmail.com"
    ]
    
    let requestCreator = RequestCreator(
        path: UserApiPath.login.rawValue,
        scheme: "http",
        host: "localhost",
        port: 9090,
        queryParams: queryParams
    )

    Task{
        do{
            let result = try await userApi.get(requestCreator)
            switch (result){
            case .failure(let error):
                Log.e(error: error)
            case .success(let data):
                Log.s(content: "ApiSuccess \n \(data)")
            }

        }catch{
            Log.e(error: error)
        }
    }
}


func testGetUserWithPhoneNumber(){
    let userApi =  UserApi()
    let queryParams : [String : Any] = [
        "phoneNumber" : "9720502894293"
    ]
    let requestCreator = RequestCreator(
        path: UserApiPath.loginWithPhone.rawValue,
        scheme: "http",
        host: "localhost",
        port: 9090,
        queryParams: queryParams
    )
    
    Task{
        do{
            let result = try await userApi.get(requestCreator)
            switch (result){
            case .failure(let error):
                Log.e(error: error)
            case .success(let data):
                Log.s(content: "ApiSuccess \n \(data)")
            }

        }catch{
            Log.e(error: error)
        }
    }
}
