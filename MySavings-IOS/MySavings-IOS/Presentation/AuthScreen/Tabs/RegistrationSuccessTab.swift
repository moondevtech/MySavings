//
//  RegistrationSuccessTab.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct RegistrationSuccessTab: View {
    
    
    @State var imageScale : CGFloat =  0.0
    @State var successTabOffset : CGFloat = -400
    @Binding var tabSelection : Int
        
    var body: some View {
        
        VStack{
                VStack{
                    SuccessView()
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
                    .animation(.spring().delay(0.2), value: successTabOffset)
                    .onAppear{
                        successTabOffset = 0
                    }
                }
                .preferredColorScheme(.dark)
            }
    }
}

struct RegistrationSuccessTab_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationSuccessTab(tabSelection: .constant(4))
    }
}
