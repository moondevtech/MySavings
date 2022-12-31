//
//  PhoneNumberChoiceView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/12/2022.
//

import SwiftUI

struct PhoneNumberChoiceView: View {
    
    @State var phoneNumber : String = "0502894293"
    @State var phoneNumberChecked : Bool = false
    @State var offsetError : CGFloat = -400.0
    @State var showError : Bool = false

    @EnvironmentObject var viewModel : OtpScreenViewModel
    
    var body: some View {
        
        VStack {
            HStack{
                CountryPickerNavigator()
                VStack{
                    TextField("", text: $phoneNumber)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .frame(width: 200, height: 40, alignment : .center)
                        .multilineTextAlignment(.center)
                        .onReceive(viewModel.formattedPhoneNumberReceived, perform: { phoneNumber in
                            let splits = phoneNumber.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
                            self.phoneNumber = String("\(Array(splits)[1])")
                            showError = false
                        })
                        .frame(width: 220)
                        .background(.white)
                        .clipShape(Capsule())
                }
            }
            .onAppear{
                showError = false
            }
            
            CheckPhoneNumberButton()
            
            Text("Invalid phone number")
                .padding(.top, 30)
                .offset(x: showError ? 0 : -400)
            
        }
        .animation(.spring(), value: showError)
        .onReceive(viewModel.showError, perform: { error in
            showError =  error == .phoneNumberError
        })
        
    }
    
    
    @ViewBuilder
    func CheckPhoneNumberButton() -> some View  {
        Button {
            if let flag = viewModel.selectedFlag{
                viewModel.handlePhoneInput(
                    .number(
                        PhoneNumberCheckModel(countryCode: flag.code, dial_code: flag.dial_code, phoneNumber: phoneNumber)
                    )
                )
            }
            
        } label: {
            Text("Check phone number")
                .frame(width: 220, height: 40)
                .padding(.horizontal)
            
        }
        .frame(width: 240, height: 40)
        .background(.white)
        .clipShape(Capsule())
        .padding(.top, 140)
    }
    
    @ViewBuilder
    func CountryPickerNavigator() -> some View {
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
}

struct PhoneNumberChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberChoiceView()
            .environmentObject(OtpScreenViewModel())
            .preferredColorScheme(.dark)
    }
}
