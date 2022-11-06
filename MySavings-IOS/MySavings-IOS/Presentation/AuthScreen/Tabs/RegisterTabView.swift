//
//  RegisterTabView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct RegisterTabView: View {
    
    @State var secondTabAppeared : Bool = false
    @State var userName : String = ""
    @State var password : String = ""
    @State var isRegistering : Bool = false
    @State var showFailure : Bool = false
    @State var secondTabOffset : CGFloat = -800
    @Binding var tabSelection : Int
    
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
                    
                    TextField("Here...", text: $userName)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.white)
                    
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
                    
                    TextField("Here...", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.white)
                    
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 40)
                .offset(x: secondTabOffset)
                .animation(.spring().delay(0.6), value: secondTabOffset)
                
                
                
                Spacer()
                
                
                LetsGoButton(title: "Done !"){
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
                    withAnimation{
                        tabSelection = 3
                    }
                }
            })
            .onReceive(authViewModel.authError, perform: { error in
                isRegistering = false
                showFailure = true
            })
            .onAppear{
                secondTabOffset = 0
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
        RegisterTabView(tabSelection: .constant(2))
            .environmentObject(AuthViewModel())
    }
}
