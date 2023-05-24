//
//  UIViewController + Extensions.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 18/05/2023.
//

import Foundation
import UIKit

extension UIViewController  {
    static func load<T: UIViewController> (_ scene: String) -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: scene, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return vc
    }
}
