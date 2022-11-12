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
        let maxCardModel = viewModel.cardModel.count == 1 ? 1 : viewModel.cardModel.count > 3 ? viewModel.cardModel.count / 2 : viewModel.cardModel.count
        let cardModels =  viewModel.hideExpensesView ? viewModel.cardModel : Array(viewModel.cardModel[0..<maxCardModel])
        
        VStack{
            Label("Cards", systemImage: "creditcard")
                .frame(width: 300, alignment: .leading)
                .font(.title.bold())
            
                ForEach(cardModels, id: \.id) { card in
                    CreditCardView(card: card)
                    .onTapGesture {
                        viewModel.selectCard(card)
                    }
                   // .animation(.linear, value: card.isSelected)
                }
        }
        .transition(.move(edge: .bottom))
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
            .environmentObject(WalletViewModel())
    }
}
