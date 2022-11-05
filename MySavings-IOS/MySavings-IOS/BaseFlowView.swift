//
//  ContentView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI
import CoreData

struct BaseFlowView: View {
    
    @StateObject var router : Router = .init()
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        
        NavigationStack(path: $router.navigationPath) {
            ProgressView()
                .preferredColorScheme(.dark)
                .navigationDestination(for: Router.AuthScreen.self) { auth in
                    AuthScreen()
                        .environmentObject(router)
                        .navigationBarBackButtonHidden()
                }
                .navigationDestination(for: Router.MainScreen.self) { main in
                    WalletView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(router)

                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        router.navigateToAuth()
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BaseFlowView().environment(\.managedObjectContext, PersistenceController.shared.context)
    }
}
