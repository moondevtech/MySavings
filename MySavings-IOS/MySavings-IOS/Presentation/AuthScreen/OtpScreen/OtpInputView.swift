//
//  OtpInputView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/12/2022.
//

import SwiftUI

struct OtpInputView: View , OtpViewScrolled {
    
    var index: Int = 0
    
    enum OtpState {
        case idle , valid, error
    }
    
    enum FocusDigit : CaseIterable {
        case one, two, three, four
        var next : FocusDigit? {
            switch self {
            case .one:
                return .two
            case .two:
                return .three
            case .three:
                return .four
            case .four:
                return .four
            }
        }
        
        var previous : FocusDigit? {
            switch self {
            case .one:
                return .one
            case .two:
                return .one
            case .three:
                return .two
            case .four:
                return .three
            }
        }
        
    }
    
    @EnvironmentObject var viewModel : OtpScreenViewModel
    @FocusState var focusState : FocusDigit?
    @State var isValid : OtpState = .idle

    var body: some View {
        ZStack{
            HStack{
                if viewModel.digits.count > 0 {
                    OneCaseField(digit: $viewModel.digits[0])
                        .focused($focusState, equals: .one)
                      //  .onAppear(perform: updateFocusState)
                }
                
                if viewModel.digits.count > 1 {
                    OneCaseField(digit: $viewModel.digits[1])
                        .focused($focusState, equals: .two)
                        .onAppear(perform: updateFocusState)
                }
                
                if viewModel.digits.count > 2 {
                    OneCaseField(digit: $viewModel.digits[2])
                        .focused($focusState, equals: .three)
                        .onAppear(perform: updateFocusState)
                }
                if viewModel.digits.count > 3 {
                    OneCaseField(digit:  $viewModel.digits[3])
                        .focused($focusState, equals: .four)
                        .onAppear(perform: updateFocusState)
                }
            }
            .animation(.spring(), value: viewModel.digits)
            .onReceive(viewModel.digitIndexToRemoveAnimateOut, perform:animateDigitOut(_:))
            .onReceive(viewModel.showError, perform: handleError(_:))
            .onReceive(viewModel.$digits, perform: handleDigits(_:))
            .onReceive(viewModel.finishedRemovingEvent) { _ in
                focusState = .one
            }
            ChangePhoneNumberButton()
        }
        .onReceive(viewModel.moveFirstDigitIn, perform: { animateDigitIn(at:$0)})
        .preferredColorScheme(.dark)
        .onAppear(perform: onViewAppeared)
        
    }
    
    @ViewBuilder
    func ChangePhoneNumberButton() -> some View {
        GeometryReader { geo in
            let frame =  geo.frame(in : .global)
            Button {
                isValid = .idle
                focusState = nil
                viewModel.handleInput(.changePhoneNumber)
            } label: {
                Text("Change phone number")
                    .foregroundColor(.white)
                    .frame( height: 40, alignment: .center)
                    .padding(.horizontal)
            }
            .frame(height: 40, alignment: .center)
            .background(.white.opacity(0.2))
            .clipShape(Capsule())
            .position(x: frame.minX + 120, y: frame.maxY - 100)
            .opacity(0.8)
        }
    }
    
    @ViewBuilder
    func OneCaseField(digit : Binding<DigitModel>) -> some View {
        
        let indexDelay =  Double(viewModel.digits.firstIndex(of: digit.wrappedValue) ?? 0)
        
        OtpFieldView(viewModel: viewModel)
            .isOtpFieldValid(isValid: $isValid,delay : indexDelay * 0.2)
            .onTapGesture(perform: {viewModel.handleInput(.remove)})
            .frame(width: 50, height: 50)
    }
    
    
    private func onViewAppeared(){
        animateDigitIn(at: 0)
    }
    
    
    private func updateFocusState(){
        if let next = focusState?.next{
            focusState = next
        }
    }
    
    private func animateDigitIn(at index : Int){
        viewModel.digits[index].x = 0
    }
    
    private func animateDigitOut(_ index : Int) {
        isValid = .idle
        viewModel.digits[index].x = CGFloat(300 * index)
        focusState = .one

    }
    
    private func handleError(_ error : OtpScreenError){
        //handle digits error
        isValid =  .error
    }
    
    private func handleDigits(_ digits : [DigitModel]){
        guard digits.filter({ !$0.value.isEmpty}).count > 3 else {
            return
        }
        //validate digits
        isValid = .valid
        // test delay
        DispatchQueue.main.asyncAfter(deadline : .now() + 0.5){
            let ds =  digits.map(\.value).joined(separator: "")
            viewModel.handleInput(.validateDigits(ds))
        }
    }
    

}

struct OtpInputView_Previews: PreviewProvider {
    static var previews: some View {
        OtpInputView()
            .environmentObject(OtpScreenViewModel())
    }
}
