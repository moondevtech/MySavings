//
//  WalletView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI
import Combine
import Charts

struct WalletView: View {
    
    @StateObject var walletViewModel : WalletViewModel = .init()
    @State var showBigCard : Bool = false
    @State var showPaymentsForDate : Bool = false
        
    var body: some View {
        ScrollView{
                        
            MonthAllowedBudgetView()
            
            if showBigCard{
                SelectedCardView(card: walletViewModel.selectedCard)
            }else{
                VStack{
                    ExpensesView()
                    CardListView()
                        .padding(.top, 40)
                    
                }
                .animation(.linear, value: walletViewModel.selectedCardTransactions)
            }
            
        }
        .environmentObject(walletViewModel)
        .animation(.linear, value: showBigCard)
        .preferredColorScheme(.dark)
        .onReceive(walletViewModel.$selectedCard) { card in
            showBigCard = card.isSelected
        }
        .onReceive(walletViewModel.$cardUsedForPayment) { cards in
            guard !cards.isEmpty else {return}
            showPaymentsForDate = !cards.isEmpty
        }
        .sheet(isPresented: $showPaymentsForDate) {
            SelectedCardsView(cards: walletViewModel.cardUsedForPayment)
        }
    }
}


struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
