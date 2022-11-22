//
//  WalletView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI
import Combine
import Charts

struct ExpensesScreen: View {
    
    @StateObject var viewModel : ExpensesScreenViewModel = .init()
    @StateObject var cardStackViewModel : CardStackViewModel = .init()
    @State var selectedCards : SelectedCardContent? = nil
    
    var body: some View {
        ZStack {
            Color.black
            VStack{
                
                BudgetView(needsRefresh: .constant(.init()))
                
                
                ExpensesView()
                    .padding(.top, 40)
                
                Spacer()
            }

            .environmentObject(viewModel)
            .animation(.spring(), value: viewModel.expensesGraphData)

            .preferredColorScheme(.dark)
            .onAppear{
                cardStackViewModel.handleInput(.fetchCards)
            }
            .onReceive(cardStackViewModel.$cards, perform: { cards in
                viewModel.getTransactions(cards)
            })
            .onReceive(viewModel.cardUsedForPayment) { cards in
                guard !cards.isEmpty else {return}
                selectedCards =  SelectedCardContent(cardModels: cards)
            }
            .sheet(item: $selectedCards, content: { content in
                SelectedCardsView(cards: content.cardModels)
            })
        }
    }
}



struct ExpensesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesScreen()
    }
}
