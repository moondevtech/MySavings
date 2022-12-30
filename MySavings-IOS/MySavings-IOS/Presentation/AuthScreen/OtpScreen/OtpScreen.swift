//
//  OtpScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 29/12/2022.
//

import SwiftUI
import Combine

struct OtpScreen: View {

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
    
    @State var phoneNumber : String = "0502894293"
    @State var textSearch : String = ""
    @StateObject var viewModel : OtpScreenViewModel = .init()
    @FocusState var focusState : FocusDigit?
    
    var body: some View {
        
        
        NavigationView {
            VStack{
                Spacer()
                HStack{
                    CountryPickerNavigtor()
                    VStack{
                        TextField("", text: $phoneNumber)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                            .frame(width: 200, height: 40, alignment : .center)

                    }
                    .frame(width: 240)
                    .background(.white)
                    .clipShape(Capsule())
                }
                
                Spacer()
                
                HStack{
                    if viewModel.digits.count > 0 {
                        OneCaseField(digit: $viewModel.digits[0])
                            .focused($focusState, equals: .one)
                            .onAppear(perform: updateFocusState)
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
                
                Spacer()
            }
            .animation(.spring(), value: viewModel.digits)
            .onReceive(viewModel.digitIndexToRemoveAnimateOut, perform: { index in
                animateDigitOut(at: index)
            })
            .onReceive(viewModel.moveFirstDigitIn, perform: { animateDigitIn(at:$0)})
            .preferredColorScheme(.dark)
            .onAppear(perform: onViewAppeared)
            .navigationBarTitle("")
        }
    }
    
    @ViewBuilder
    func CountryPickerNavigtor() -> some View {
        NavigationLink {
            OtpCountryPickerView()
                .environmentObject(viewModel)
        } label: {
            Text("\(viewModel.selectedFlag!.emoji) \(viewModel.selectedFlag!.dial_code)")
                .frame(width:80 ,height: 40, alignment : .center)
                .background(.white)
                .foregroundColor(.black)
                .clipShape(Capsule())
        }
    }
    
    
    @ViewBuilder
    func OneCaseField(digit : Binding<DigitModel>) -> some View {
        ZStack{
            OtpFieldView(viewModel: viewModel)
        }
        .frame(width: 50, height: 50)
        .foregroundColor(.black)
        .background(Color.white)
        .cornerRadius(25)
        .offset(x:digit.wrappedValue.x)
    }
    
    private func onChangeDigitValue( _ newValue : String) {
        if newValue.isEmpty{
            viewModel.handleInput(.animateOut)
        }else{
            print(newValue)
            if newValue.count == 1 {
                viewModel.handleInput(.digit(String(newValue.prefix(1))))
            }else{
                viewModel.handleInput(.remove)
            }
        }
    }
    
    private func onViewAppeared(){
        moveFirstDigit()
    }
    
    private func moveFirstDigit(){
        animateDigitIn(at: 0)
        focusState = .one
    }
    
    private func updateFocusState(){
        if let next = focusState?.next{
            focusState = next
        }
    }
    
    private func animateDigitIn(at index : Int){
        viewModel.digits[index].x = 0
    }
    
    private func animateDigitOut(at index : Int) {
        viewModel.digits[index].x = CGFloat(300 * index)
    }
}

struct OtpScreen_Previews: PreviewProvider {
    static var previews: some View {
        OtpScreen()
    }
}
