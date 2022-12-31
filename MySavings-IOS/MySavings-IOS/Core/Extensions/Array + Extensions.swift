//
//  Array + Extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation


extension Array where Element : Identifiable {
    
    var lastModifiable : Element {
        get { self[self.count-1] }
        set { self[self.count-1] = newValue }
    }
    
}
