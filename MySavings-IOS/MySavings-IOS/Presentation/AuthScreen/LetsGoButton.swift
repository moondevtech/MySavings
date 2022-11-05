//
//  LetsGoButton.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct LetsGoButton: View {
    
    var title : String
    var action : () -> Void
    
    init(title: String = "Lets go", action : @escaping () -> Void = {}) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .padding(.horizontal)
        })
        .foregroundColor(.black)
        .font(.body.bold())
        .frame(height: 60)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.top, 40)
    }
}

struct LetsGoButton_Previews: PreviewProvider {
    static var previews: some View {
        LetsGoButton()
    }
}
