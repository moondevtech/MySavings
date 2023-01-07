//
//  RegisterTabView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct RegisterTabView: View {
    
    enum FocusedField {
        case username, password
    }
    
    @FocusState private var focusedField: FocusedField?

    
    @State var secondTabAppeared : Bool = false
    @State var userName : String = ""
    @State var userNameCorrect : Bool = true
    @State var password : String = ""
    @State var isRegistering : Bool = false
    @State var showFailure : Bool = false
    @State var secondTabOffset : CGFloat = -800
    @Binding var authTabselection : AuthScreen.AuthTab

    
    @EnvironmentObject var authViewModel : AuthViewModel
    
    
    var body: some View {
        ZStack {
            VStack{
                TitleTab(content: "About you")
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: secondTabOffset)
                    .animation(.spring().delay(0.2), value: secondTabOffset)
                
                Spacer()
                
                VStack{
                    Text("Username")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body.bold())
                        .foregroundColor(.white)
                    
                    ValidationField(value: $userName) { input in
                        input.count > 3
                    }
                    .focused($focusedField, equals: .username)
                    .submitLabel(.continue)
                                        
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .offset(x: secondTabOffset)
                .animation(.spring().delay(0.4), value: secondTabOffset)
                
                
                
                VStack{
                    Text("Password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body.bold())
                        .foregroundColor(.white)
                    
                    ValidationField(value: $password) { input in
                        input.count > 3
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)

                    
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 40)
                .offset(x: secondTabOffset)
                .animation(.spring().delay(0.6), value: secondTabOffset)
                
                
                
                Spacer()
                
                
                LetsGoButton(title: "Done !"){
                    hideKeyboard()
                    isRegistering = true
                    authViewModel.handleInput(authInput: .register(.init(name: userName, password: password)))
                }
                .padding(.bottom, 80)
                .offset(x: secondTabOffset)
                .animation(.spring().delay(0.8), value: secondTabOffset)
                
            }
            .padding()
            .preferredColorScheme(.dark)
            .onReceive(authViewModel.isRegistered, perform: { isRegistered in
                isRegistering = false
                if isRegistered{
                    withAnimation(.spring()){
                        authTabselection = .otp
                    }
                }
            })
            .onSubmit {
                if focusedField == .username {
                    focusedField = .password
                } else {
                    focusedField = nil
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onReceive(authViewModel.authError, perform: { error in
                isRegistering = false
                showFailure = true
            })
            .onAppear{
                secondTabOffset = 0
            }
            .onDisappear{
                focusedField = nil
            }
            .sheet(isPresented: $showFailure) {
                userName = ""
                password = ""
            } content: {
                FailureScreen()
            }
            
            if isRegistering{
                Color.black.opacity(0.3)
                ProgressView()
            }
        }
    }
}



struct RegisterTabView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterTabView(authTabselection: .constant(.registration))
            .environmentObject(AuthViewModel())
    }
}
