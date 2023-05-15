//
//  MySavings_IOSApp.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI

@main
struct MySavings_IOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            OtpScreen(authTabselection : .constant(.otp))
           BaseFlowView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

