//
//  Router.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import SwiftUI

enum ScreenRoute :  Hashable{
    
    case auth, main, details(String)
    
    var id : Int {
        switch self {
        case .auth:
            return 0
        case .main:
            return 1
        case .details:
            return 2
        }
    }
}


class Router: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
        
    func navigateToMain() {
        navigationPath.append(ScreenRoute.main)
    }
    
    func navigateToAuth() {
        navigationPath.append(ScreenRoute.auth)
    }
    
    func navigateToCardDetails(_ cardId : String) {
        navigationPath.append(ScreenRoute.details(cardId))
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}

