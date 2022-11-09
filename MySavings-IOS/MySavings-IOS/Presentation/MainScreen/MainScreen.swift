//
//  MainScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

let shekel = "₪"

struct MainScreen: View {
    
    @StateObject var viewModel : BudgetViewVM = .init()
    
    
    var body: some View {
        HStack{
            Text("\(viewModel.percentSpent.formatted(formatting: .percent))")
        }
        .onAppear{
            viewModel.getBudget()
            viewModel.onReceive()
        }
    }
}


enum BudgetInput {
    case fetchBudget
}



class BudgetViewVM : ObservableObject {
    
    @CurrentUser(isMock: true) var user
    @Published var amountAllocated : Double = 0.0
    @Published var amounSpent: Double = 0.0
    @Published var percentSpent : Double = 0.0
    let valuesReceived = PassthroughSubject<Double, Never>()

    
    var subscriptions : Set<AnyCancellable> = .init()
    
    func onReceive(){
        $amountAllocated
            .zip($amounSpent)
            .map{max , spent  in
                return 100 * spent / max
            }
            .assign(to: &$percentSpent)
        
    }
    
    func getBudget(){
        
        let userBudget = user[keyPath: \.cards]
            .publisher
            .compactMap({ card in
                card.budgets
            })
        
       let amounts = userBudget.flatMap{ budgets in
            budgets
                .publisher
                .eraseToAnyPublisher()
                .map(\.maxAmount)
                .reduce(0.0) { acc, next in
                    acc + next
                }
        }
        .collect()
        .map{amounts in
            amounts.reduce(0.0) { counter, value  in counter + value }
        }
        
        
       let spent =  userBudget.flatMap{ budgets in
            budgets
                .publisher
                .eraseToAnyPublisher()
                .map(\.amountSpent)
                .reduce(0.0) { acc, next in
                    acc + next
                }
        }
        .collect()
        .map{amounts in
            amounts.reduce(0.0) { counter, value  in counter + value }
        }
        
        Publishers.Zip(amounts, spent)
            .sink { amount, spent in
                self.amountAllocated = amount
                self.amounSpent = spent
            }
            .store(in: &subscriptions)
       // .assign(to: &$amounSpent)
 
        
        // user[\.cards].first?.budgets?.first?.amountSpent
        // user[\.cards].first?.budgets?.first?.maxAmount
    }
    
    
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
        
    }
}
