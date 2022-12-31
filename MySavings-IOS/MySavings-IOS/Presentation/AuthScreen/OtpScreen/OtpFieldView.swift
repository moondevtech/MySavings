//
//  OtpFieldView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import SwiftUI
import UIKit

struct OtpFieldView : UIViewRepresentable {
    
    
    @StateObject var viewModel : OtpScreenViewModel
    //@Binding var digit : DigitModel
    
    func makeCoordinator() -> Coordinator {
        let coordinator =   Coordinator(parent: self)
        return coordinator
    }
    
    func makeUIView(context: Context) -> UITextField {
        let  uitextField =  UITextField(frame: CGRect(origin: .zero, size: .init(width: 50, height: 50)))
        uitextField.layer.cornerRadius = 25
        uitextField.textColor = .black
        uitextField.backgroundColor = .white
        uitextField.text = viewModel.digits.last?.value
        uitextField.textAlignment = .center
        return uitextField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.delegate = context.coordinator
        if viewModel.digits.count < 2 {
            uiView.text = viewModel.digits.last?.value
        }
    }
    
    class Coordinator : NSObject, UITextFieldDelegate {
        
        var parent : OtpFieldView
        var textField : UITextField?
        
        init(parent : OtpFieldView) {
            self.parent = parent
            super.init()

        }
    
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if let text = textField.text{
                if text.count > 0 {
                    return false
                }else{
                    return true
                }
            }
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if let current =  textField.text{
                if string == "" {
                    parent.viewModel.digits[3].value = ""
                    parent.viewModel.handleInput(.animateOut)
                    return true
                }
                
                if current.count > 0  {
                    return false
                }
            }
            parent.viewModel.handleInput(.digit(string))
            return true
        }
        
    }
    
    
    typealias UIViewType = UITextField
    
    
}
