//
//  SuccessView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct SuccessView: View {
        
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

    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
