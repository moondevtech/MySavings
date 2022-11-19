//
//  HomeScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var needsRefreshing : UUID = .init()
    @State var viewModel : HomeScreenViewModel = .init()
    
    var body: some View {
        VStack{
            BudgetView(needsRefresh : $needsRefreshing)
            Spacer()
            CardStackView()
        }
        .onReceive(viewModel.needsRefresh, perform: { _ in
            self.needsRefreshing = .init()
        })
        .environmentObject(viewModel)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
