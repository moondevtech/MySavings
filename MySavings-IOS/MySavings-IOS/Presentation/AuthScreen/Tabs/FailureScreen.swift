//
//  FailureScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import SwiftUI

struct FailureScreen: View {
    
    @State var imageScale : CGFloat =  0.0
    @State var successTabOffset : CGFloat = -400
    @State var receivedError : AuthError = .none
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            
            FailureView()
            
            HStack(spacing: 50){
                LetsGoButton(title: "Lets retry !") {
                    withAnimation{
                        dismiss.callAsFunction()
                    }
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

struct FailureScreen_Previews: PreviewProvider {
    static var previews: some View {
        FailureScreen()
    }
}
