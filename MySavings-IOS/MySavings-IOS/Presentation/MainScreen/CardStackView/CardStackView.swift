//
//  CardStackView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct CardStackView: View {
    
    @StateObject var viewModel : CardStackViewModel = .init()
    @EnvironmentObject var router : Router
    @State var cardToShow : CardModel?
    
    var body: some View {
        ScrollView{
            ForEach(viewModel.cards.reversed(), id:\.self) { card in
                CreditCardView(card: card)
                    .environmentObject(viewModel)
            }
        }
        .animation(.spring().delay(0.1), value: viewModel.cards)
        .onReceive(viewModel.toCarddetailsEvent, perform: { cardDetails in
            cardToShow = cardDetails
        })
        .sheet(item: $cardToShow, content: { cardModel in
            CardDetailsScreen(id: cardModel.id)
        })
        .onAppear{
            viewModel.handleInput(.fetchCards)
        }
        .onDisappear{
            viewModel.cards = .init()
        }
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView()
            .environmentObject(Router())
    }
}
