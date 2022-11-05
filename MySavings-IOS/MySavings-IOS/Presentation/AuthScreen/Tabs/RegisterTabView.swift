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
    @State var secondTabOffset : CGFloat = -400
    
    @Binding var tabSelection : Int
    
    
    var body: some View {
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
                //save user
                withAnimation{
                    tabSelection = 3
                }
            }
            .padding(.bottom, 80)
            .offset(x: secondTabOffset)
            .animation(.spring().delay(0.8), value: secondTabOffset)
            
            
        }
        .padding()
        .preferredColorScheme(.dark)
        .onAppear{
            secondTabOffset = 0
        }
    }
}

struct RegisterTabView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterTabView(tabSelection: .constant(2))
    }
}
