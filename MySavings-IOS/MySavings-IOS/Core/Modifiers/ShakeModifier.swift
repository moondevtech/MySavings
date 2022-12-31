//
//  ShakeModifier.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/12/2022.
//

import Foundation
import SwiftUI

struct Shake: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

extension View {
    func shake(shakes : Int ) -> some View {
        modifier(Shake(shakes: shakes ))
    }
}
