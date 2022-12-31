//
//  ValidOtpModifiers.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/12/2022.
//

import Foundation
import SwiftUI

struct ValidOtpModifier : ViewModifier  {
    
    @Binding var isValid : OtpInputView.OtpState
    var delay : Double
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Circle()
                    .trim(from: 0, to: isValid == .valid || isValid == .error ? 1 : 0)
                    .stroke(lineWidth: 2)
                    .foregroundColor(isValid == .valid ? .green : .red)
            }
            .animation(.linear.delay(delay), value: isValid)
    }
}


extension OtpFieldView {
    func isOtpFieldValid(isValid : Binding<OtpInputView.OtpState>,  delay : Double = 0.0) -> some View {
       modifier(ValidOtpModifier(isValid: isValid, delay: delay))
    }
    
}
