//
//  DynamicReference.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation

@dynamicMemberLookup
class DynamicReference<Value> {
    
    private(set) var value: Value

    init(value: Value) {
        self.value = value
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get {  value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
