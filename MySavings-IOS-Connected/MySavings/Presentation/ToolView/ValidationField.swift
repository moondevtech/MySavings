//
//  ValidationField.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 08/11/2022.
//

import SwiftUI


enum ValidationFieldState   {
    case idle , checked(Bool)
}

struct ValidationField: View {
    
    private var placeholder : String = "Here..."
    private var validityCheck : (String) -> Bool
    @Binding var value : String
    
    //@State var state : ValidationFieldState = .idle
    @State var isCorrect : Bool = true
    
    init(
        placeholder: String  = "Here...",
        value: Binding<String>,
        check : @escaping (String) -> Bool
    ) {
        self.placeholder = placeholder
        self._value = value
        self.validityCheck = check
    }
    
    var body: some View {
        GeometryReader { geo in
            let frame = geo.frame(in: .local)
            TextField(placeholder, text: $value)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.white)
                .onSubmit {
                    withAnimation{
                        isCorrect = validityCheck(value)
                    }
                }
            
            Rectangle()
                .position(x: frame.width / 2, y: frame.height * 0.9)
                .frame(width: isCorrect ? 0 : frame.width, height: 1)
                .foregroundColor(.red)
            
        }
        .frame(height: 40)
        .preferredColorScheme(.dark)
    }
}

struct ValidationField_Previews: PreviewProvider {
    static var previews: some View {
        ValidationField(value: .constant("Hello"), check: { value in
            value.count > 5
        })
    }
}
