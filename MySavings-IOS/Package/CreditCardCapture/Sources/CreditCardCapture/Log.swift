//
//  File.swift
//  
//
//  Created by Ruben Mimoun on 23/05/2023.
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
              ℹ️ \n- \(content) \n
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
