//
//  CardDetailsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct CardDetailsScreen: View {
    var id : String
    
    @State var card : CardModel = .init(cardData: .init())
    @State var scaleEffect = 0.0
    @State var newTransaction : NewTransactionModel = .init()
    
    @StateObject var viewModel = CardDetailsScreenViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $newTransaction.tabTransaction) {
                BudgetAndTransactions()
                    .tag(0)
                
                BudgetListScreen(newTransaction: $newTransaction)
                    .tag(1)
                
                NewTransactionFormScreen(newTransaction: $newTransaction)
                    .tag(2)

            }
            .environmentObject(viewModel)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(), value : newTransaction.tabTransaction)
            .onReceive(viewModel.cardFoundEvent, perform: { card in
                self.card =  card
            })
            .onAppear{
                viewModel.handleInput(.fetchCard(id))
            }
            .onReceive(viewModel.transactionSavedEvents, perform: { _ in
                viewModel.handleInput(.fetchCard(id))
                
            })
            .toolbar {
                ToolbarItem(placement : .navigationBarLeading) {
                    Button {
                        newTransaction.tabButtonNavigation()
                    } label: {
                        Image(systemName: newTransaction.tabImage)
                            .foregroundColor(.white)
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func Header() -> some View {
        BudgetView(cardId: id)
            .padding(.bottom, 40)
        
        CreditCardView(card: card, isNavigatable: false)
            .scaleEffect(scaleEffect)
    }
    
    
    
    @ViewBuilder
    func BudgetAndTransactions() ->some View{
        CardBudgetListScreenView(header: {
            Header()
        })
        .navigationBarTitle("")
        .onAppear{
            withAnimation {
                scaleEffect = 1.5
            }
        }
    }
}

struct CardDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsScreen(id: "")
    }
}
