//
//  Router.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import SwiftUI


class Router: ObservableObject {

    
    struct AuthScreen : ScreenDelegate {
        var id: Int { return 1 }        
    }
    
    struct MainScreen : ScreenDelegate {
        var id: Int { return 2}
    }
    
    @Published var navigationPath = NavigationPath()
    
    func navigateToMain() {
        navigationPath.append(MainScreen())
    }
    
    func navigateToAuth() {
        navigationPath.append(AuthScreen())
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}

