//
//  CardStackView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct CardStackView: View {
    
    @EnvironmentObject var cardStackViewModel : CardStackViewModel
    @EnvironmentObject var router : Router
    @EnvironmentObject var parentVientModel : HomeScreenViewModel

    @State var cardToShow : CardModel?
    
    var body: some View {
        ScrollView{
            ForEach(cardStackViewModel.cards.reversed(), id:\.self) { card in
                CreditCardView(card: card)
            }
        }
        .animation(.spring().delay(0.1), value: cardStackViewModel.cards)
        .onReceive(cardStackViewModel.toCarddetailsEvent, perform: { cardDetails in
            cardToShow = cardDetails
        })
        .sheet(item: $cardToShow,onDismiss: {
            parentVientModel.handleInput(.refresh)
        }, content: { cardModel in
            CardDetailsScreen(id: cardModel.id)
        })

        .onAppear{
            cardStackViewModel.handleInput(.fetchCards)
        }
        .onDisappear{
            cardStackViewModel.cards = .init()
        }
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView()
            .environmentObject(CardStackViewModel())
            .environmentObject(Router())
            .environmentObject(HomeScreenViewModel())
    }
}
