//
//  MainScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

let shekel = "₪"

struct MainScreen: View {
    
    var body: some View {
        VStack{
            BudgetView()
            Spacer()
        }
    }

}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
