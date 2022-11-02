//
//  ScrollViewOffsetPreferenceKey.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 01/11/2022.
//

import Foundation
import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
    
}
