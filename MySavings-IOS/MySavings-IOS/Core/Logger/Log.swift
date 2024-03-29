//
//  Log.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation

struct Log {
    
    static func e(line : Int = #line,
                  function : String = #function ,
                  file : String = #file,
                  error : any Error
    ){
        print("""
              ⭕️ - \(error.localizedDescription) \n
                line - \(line)
                function - \(function)
                class - \(file)
        """)
    }
    
    static func s(line : Int = #line,
                  function : String = #function ,
                  file : String = #file,
                  content : Any
    ){
        print("""
              ✅ - \(content) \n
                line - \(line)
                function - \(function)
                class - \(file)
        """)
    }
    
    static func i(line : Int = #line,
                  function : String = #function ,
                  file : String = #file,
                  content : Any
    ){
        print("""
              ℹ️ - \(content) \n
                line - \(line)
                function - \(function)
                class - \(file)
        """)
    }
    
    static func w(line : Int = #line,
                  function : String = #function ,
                  file : String = #file,
                  content : Any
    ){
        print("""
              ⚠️ - \(content) \n
                line - \(line)
                function - \(function)
                class - \(file)
        """)
    }
}
