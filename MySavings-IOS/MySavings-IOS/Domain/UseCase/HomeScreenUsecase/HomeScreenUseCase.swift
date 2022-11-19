//
//  HomeScreenUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

class HomeScreenUseCase {
    weak var delegate : HomeScreenOutputType?
    
    init(delegate: HomeScreenOutputType) {
        self.delegate = delegate
    }
    
    func refresh() {
        delegate?.handleOutput(.refreshed)
    }
}
