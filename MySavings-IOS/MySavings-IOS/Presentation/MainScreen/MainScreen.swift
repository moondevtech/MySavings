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
    
    @StateObject var viewModel : CardStackViewModel = .init()
    var body: some View {
        VStack{
            BudgetView()
                .padding(.top, 80)
            Spacer()
            CardStackView()
        }
    }

}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
