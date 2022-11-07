//
//  View.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 07/11/2022.
//

import Foundation
import SwiftUI
import UIKit

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

