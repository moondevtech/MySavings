//
//  MySavings_IOSApp.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI

@main
struct MySavings_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            BaseFlowView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear{
                    testPostApi()
                }
        }
    }
}

