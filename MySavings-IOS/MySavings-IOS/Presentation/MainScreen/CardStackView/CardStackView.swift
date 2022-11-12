//
//  CardStackView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct CardStackView: View {
    
    @EnvironmentObject var viewModel : CardStackViewModel
    @EnvironmentObject var router : Router
    @State var cardToShow : CardModel?
    
    var body: some View {
        ScrollView{
            ForEach(viewModel.cards.reversed(), id:\.self) { card in
                CreditCardView(card: card)
            }
        }
        .animation(.spring().delay(0.1), value: viewModel.cards)
        .onReceive(viewModel.toCarddetailsEvent, perform: { cardDetails in
            cardToShow = cardDetails
           // router.navigateToCardDetails(cardDetails.id)
        })
        .onReceive(viewModel.userHasChanged, perform: { _ in
            viewModel.handleInput(.fetchCards)
        })
        .sheet(item: $cardToShow, content: { cardModel in
            CardDetailsScreen(id: cardModel.id)
        })
        .onDisappear{
            viewModel.cards = .init()
        }
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView()
            .environmentObject(CardStackViewModel())
            .environmentObject(Router())
    }
}
