//
//  RegistrationSuccessTab.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct RegistrationSuccessTab: View {
    
    
    @State var imageScale : CGFloat =  0.0
    @State var successTabOffset : CGFloat = -800
    @Binding var tabSelection : Int
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        
        VStack{
            SuccessView()
                .scaleEffect(imageScale)
                .animation(.spring().delay(0.8), value: imageScale)
            
            HStack(spacing: 50){
                LetsGoButton(title: "Add a card ?") {
                    withAnimation{
                        tabSelection = 4
                    }
                }
                
                LetsGoButton(title: "Skip") {
                    //Reach main app
                }
            }
            .offset(x: successTabOffset)
            .animation(.spring().delay(0.6), value: successTabOffset)
        }
        .onReceive(authViewModel.showTab, perform: { tabIndex in
            if tabIndex == tabSelection{
                successTabOffset = 0
                imageScale = 1.0
            }
        })
        .onAppear{

            
        }
    }
}

struct RegistrationSuccessTab_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationSuccessTab(tabSelection: .constant(3))
            .environmentObject(AuthViewModel())
    }
}
