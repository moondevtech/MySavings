//
//  FailureView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import SwiftUI

struct FailureView: View {
    @State var imageScale : CGFloat = 0.0
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.red)
                .frame(width: 200)
            Image(systemName: "xmark")
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

struct FailureView_Previews: PreviewProvider {
    static var previews: some View {
        FailureView()
    }
}
