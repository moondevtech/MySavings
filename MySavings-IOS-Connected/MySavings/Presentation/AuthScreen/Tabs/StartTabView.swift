//
//  StartTabView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct StartTabView: View {
    
    @State var firstTabXOffset : CGFloat = -400
    @Binding var tabSelection : Int 
    
    var body: some View {
        VStack{
            TitleTab(content: "Start saving money !")
                .offset(x: firstTabXOffset)
                .animation(.spring().delay(0.3),value: firstTabXOffset)
            
            LetsGoButton(title: "Let's go!"){
                withAnimation(.spring()){
                    tabSelection = 2
                }
            }
            .offset(x: firstTabXOffset)
            .animation(.spring().delay(0.6), value: firstTabXOffset)
            
        }
        .preferredColorScheme(.dark)
        .onAppear{
            firstTabXOffset = 0 
        }
    }
}

struct StartTabView_Previews: PreviewProvider {
    static var previews: some View {
        StartTabView(tabSelection: .constant(1))
    }
}
