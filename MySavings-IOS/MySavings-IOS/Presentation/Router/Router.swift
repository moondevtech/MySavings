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
    
    @Published var routes : [ScreenRoute] = [ScreenRoute.loading]
    
    func navigateToMain() {
        routes.append(ScreenRoute.main)
    }
    
    func navigateToAuth() {
        routes.append(ScreenRoute.auth)
    }
    
    func navigateToCardDetails(_ cardId : String) {
        routes.append(ScreenRoute.details(cardId))
    }
    
    func navigateBack() {
        routes.removeLast()
    }
    
    func navigateToRoot() {
        routes = [ScreenRoute.loading]
    }
}

