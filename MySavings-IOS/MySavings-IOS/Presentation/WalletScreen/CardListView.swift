//
//  CardListView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import SwiftUI

struct CardListView: View {
    
    @EnvironmentObject var viewModel : WalletViewModel
    
    var body: some View {
        VStack{
            Label("Cards", systemImage: "creditcard")
                .frame(width: 300, alignment: .leading)
                .font(.title.bold())
            
            LazyVStack{
                ForEach(viewModel.cardModel, id: \.id) { card in
                    CreditCardView(card: card)
                    .onTapGesture {
                        viewModel.selectCard(card)
                    }
                    .animation(.linear, value: card.isSelected)
                }
            }
        }
        .safeAreaInset(edge: .top, content: {
            if viewModel.hideExpensesView{
                Color.clear
                    .frame(height : 140)
            }
        })
        .transition(.move(edge: .bottom))
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
            .environmentObject(WalletViewModel())
    }
}
