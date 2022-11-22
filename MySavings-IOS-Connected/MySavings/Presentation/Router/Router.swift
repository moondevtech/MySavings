//
//  Router.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import SwiftUI

enum ScreenRoute :  Hashable{
    
    case loading ,auth, main, details(String)
    
    var id : Int {
        switch self {
        case .loading:
            return 0
        case .auth:
            return 1
        case .main:
            return 2
        case .details:
            return 3
        }
    }
}


class Router: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    @Published var routes : [ScreenRoute] = [ScreenRoute.loading]

        
    func navigateToMain() {
        navigationPath.append(ScreenRoute.main)
        routes.append(ScreenRoute.main)

    }
    
    func navigateToAuth() {
        navigationPath.append(ScreenRoute.auth)
        routes.append(ScreenRoute.auth)

        
    }
    
    func navigateToCardDetails(_ cardId : String) {
        navigationPath.append(ScreenRoute.details(cardId))
        routes.append(ScreenRoute.details(cardId))
    }
    
    func navigateBack() {
        navigationPath.removeLast()
        routes.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
        routes = [ScreenRoute.loading]
    }
}

