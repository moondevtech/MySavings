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
            CreditCardView(card: card)
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
        })
        .onAppear{
            withAnimation {
                scaleEffect = 1.5
            }
            viewModel.start(id: id)
        }
    }
}

class CardDetailsScreenViewModel  : ObservableObject{
    
    @CurrentUser var user
    var cardFoundEvent : PassthroughSubject<CardModel,Never> = .init()
    var subscriptions : Set<AnyCancellable> = .init()
    @Published var transactions : [TransactionData] = .init()
    
    func start(id : String){
        
        user[keyPath: \.cards]
            .publisher
            .first(where: {$0.id == id })
            .map { card in
                CardModel(cardData: .init(
                    name: card.cardHolder,
                    cardNumber : card.cardNumber,
                    expired: card.expirationDate,
                    cvv : card.cvv,
                    type: card.creditCardType.rawValue
                    )
                )
            }
            .map(\.cardData.transaction)
            .flatMap{ transactions in
                transactions
                    .publisher
                    .eraseToAnyPublisher()
                    .flatMap(maxPublishers : .max(1)){
                        Just($0).delay(for: 0.5, scheduler: DispatchQueue.main)
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { card in
                self.transactions.append(card)
            }
            .store(in: &subscriptions)
    }
    
}

struct CardDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsScreen(id: "")
    }
}
