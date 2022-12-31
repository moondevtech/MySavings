//
//  Stack.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 29/12/2022.
//

import Foundation

struct Stack<Element> {
    
    private var elements : [Element]
    
    init(){
        elements = .init()
    }
    
    init(elements: [Element]) {
        self.elements = elements
    }
    
    mutating func push(_ element : Element){
        elements.append(element)
    }
    
    mutating func pop() -> Element?{
        elements.popLast()
    }
    
    var count : Int {
        get { elements.count }
    }
    
    var isEmpty : Bool {
        elements.count == 0
    }
    
    var first : Element? {
        elements.first
    }
    
    func peek() -> Element? {
        elements.last
    }
    
}

extension Stack : ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Element
    
    
    public init(arrayLiteral elements : Element... ){
        self.elements =  elements
    }
}
