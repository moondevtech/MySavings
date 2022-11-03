//
//  SelectedCardsView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import SwiftUI

struct SelectedCardsView: View {
    
    var cards : [CardModel]
    
    @State var scaleEffect : CGFloat = 0
    @Environment (\.dismiss) var dimiss
    
    var body: some View {
        TabView {
            ForEach(cards) { card in
                VStack{
                    
                    CreditCardView(card: card)
                        .scaleEffect(scaleEffect)
                        .onTapGesture {
                            dimiss.callAsFunction()
                        }
                    
                    VStack {
                        ForEach(card.cardData.transaction, id: \.self) { transaction in
                            HStack{
                                Text(transaction.reason)
                                    .font(.body)
                                Spacer()
                                Text(transaction.amount.formatted() + "₪")
                                    .font(.body.bold())
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
                .transition(.scale)
                .padding(.top, 80 )
                .frame(width: 400)
                .onAppear{
                    withAnimation {
                        scaleEffect = 1.5
                    }
                }
                .tabItem {
                    Text(card.secretCardNumber)
                }
            }
        }
    }
}

struct SelectedCardsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedCardsView( cards: [CardModel.init(cardData: .init()),CardModel.init(cardData: .init())])
    }
}
