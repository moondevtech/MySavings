//
//  SuccessView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct SuccessView: View {
    
    @State var imageScale : CGFloat = 0.0
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.green)
                .frame(width: 200)
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.white)
        }
        .scaleEffect(imageScale)
        .animation(.spring().delay(0.4), value: imageScale)
        .onAppear{
            imageScale = 1.0
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
