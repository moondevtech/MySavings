//
//  OtpScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 29/12/2022.
//

import SwiftUI
import Combine


protocol OtpViewScrolled {
    var index : Int { get }
}

struct OtpScreen: View {
    
    let screenSize =  UIScreen.main.nativeBounds
    @State var textSearch : String = ""
    @State var displayedViewId : Int = -1
    @StateObject var viewModel : OtpScreenViewModel = .init()
    
    @Binding var authTabselection : AuthScreen.AuthTab
    
    var body: some View {
        
        VStack{
            GeometryReader { geo in
                
                let frame = geo.frame(in : .global)
                
                ScrollView{
                    ScrollViewReader{ reader in
                        VStack{
                            PhoneNumberChoiceView()
                                .frame(width: frame.width, height: frame.height  , alignment: .center)
                                .id(0)
                                .onAppear{
                                    reader.scrollTo(0)
                                }
                            
                            
                            OtpInputView()
                                .frame(width: frame.width, height: frame.height  , alignment: .center)
                                .id(1)
                            
                        }
                        .frame(width: frame.width, height: frame.height * 2  , alignment: .center)
                        .onReceive(viewModel.otpScreenScrollDestination) { destination in
                            withAnimation(.spring()){
                                reader.scrollTo(destination)
                            }
                        }
                        .onReceive(viewModel.onOtpSuccessEvent) { _ in
                            authTabselection = AuthScreen.AuthTab.success
                        }
                        
                    }
                    
                }
                
            }
            .environmentObject(viewModel)
            .navigationBarTitle("")
        }
        
    }
    
}

struct OtpScreen_Previews: PreviewProvider {
    static var previews: some View {
        OtpScreen(authTabselection: .constant(AuthScreen.AuthTab.otp))
            .environmentObject(AuthViewModel())
    }
}
