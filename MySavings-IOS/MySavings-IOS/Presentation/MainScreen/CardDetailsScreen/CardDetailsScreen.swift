//
//  CardDetailsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

struct CardDetailsScreen: View {
    var id : String
    
    @State var card : CardModel = .init(cardData: .init())
    @State var scaleEffect = 0.0
    @StateObject var viewModel = CardDetailsScreenViewModel()

    var body: some View {
        VStack{
            
            BudgetView(cardId: id)
                .padding(.bottom, 40)
            
            CreditCardView(card: card, isNavigatable: false)
                .scaleEffect(scaleEffect)
                .onTapGesture {
                }
            
            VStack {
                ForEach(viewModel.transactions.reversed(), id: \.self) { transaction in
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
        .animation(.spring(), value: viewModel.transactions)
        .transition(.scale)
        .padding(.top, 80 )
        .frame(width: 400)
        .onReceive(viewModel.cardFoundEvent, perform: { card in
            self.card =  card
            print("card", card)
        })
        .onAppear{
            withAnimation {
                scaleEffect = 1.5
            }
            viewModel.handleInput(.fetchCard(id))
        }
    }
}

struct CardDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsScreen(id: "")
    }
}
