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
    @CurrentUser var currentUser
    @StateObject var walletViewModel : WalletViewModel = .init()
    @State var showBigCard : Bool = false
    @State var showPaymentsForDate : Bool = false
    @State var defaultScrollY : CGFloat = 0.0
    
    var body: some View {
        //   let cardsPaddingTop : CGFloat = walletViewModel.hideExpensesView ? 20 : 40
        // ScrollView{
        //                GeometryReader{ geo in
        //                    Rectangle()
        //                        .frame(width: 0, height: 0)
        //                        .onAppear{
        //                            self.defaultScrollY = geo.frame(in: .global).midY
        //                        }
        //                        .onChange(of: geo.frame(in: .global).midY) { newValue in
        //                            if walletViewModel.hideExpensesView{
        //                                if newValue > defaultScrollY * 1.1 {
        //                                    withAnimation(.spring()) {
        //                                        walletViewModel.hideExpensesView = false
        //                                    }
        //                                }
        //                            }else{
        //                                if  newValue < -defaultScrollY * 1.1 {
        //                                    withAnimation(.spring()) {
        //                                        walletViewModel.hideExpensesView = true
        //                                    }
        //                                }
        //                            }
        //                        }
        //                }
        
        //            if showBigCard{
        //                SelectedCardView(card: walletViewModel.selectedCard)
        //            }else{
        ZStack {
            Color.black
            VStack{
                
                BudgetView(needsRefresh: .constant(.init()))
                
                
                ExpensesView()
                    .padding(.top, 40)
                
                Spacer()
                //                    CardListView()
                //                        .padding(.top, cardsPaddingTop)
            }
            .animation(.linear, value: walletViewModel.selectedCardTransactions)
            //}
            
            //}
            .environmentObject(walletViewModel)
            .animation(.linear, value: showBigCard)
            .preferredColorScheme(.dark)
            .onReceive(walletViewModel.$selectedCard) { card in
              //  showBigCard = card.isSelected
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
}



struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
