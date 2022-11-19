//
//  HomeScreenViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation
import Combine

class HomeScreenViewModel : ObservableObject {
    
    var needsRefresh : PassthroughSubject<Bool,Never> = .init()
    private lazy var useCase : HomeScreenUseCase = .init(delegate: self)
    
    private func handleNeedsRefresh(){
        needsRefresh.send(true)
    }
    
}

extension HomeScreenViewModel : HomeScreenInputType {
    func handleInput(_ input: HomeScreenInput) {
        switch input {
        case .refresh:
            useCase.refresh()
        }
    }
    
}

extension HomeScreenViewModel : HomeScreenOutputType {
    func handleOutput(_ output: HomeScreenOutput) {
        switch output {
        case .refreshed:
            handleNeedsRefresh()
        }
    }
}
