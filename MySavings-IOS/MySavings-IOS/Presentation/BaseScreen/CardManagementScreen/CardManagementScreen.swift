//
//  SwiftUIView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 12/11/2022.
//

import SwiftUI

struct CardManagementScreen : View {
    
    @StateObject var viewModel : CardManagementViewModel = .init()
    @State var currentCardHolder : CardHolder = .init()
    @State var showRemoveButton : Bool = false
    @State var showAddCard : Bool = false
    
    var body: some View {
        ZStack{
            Color.black
            ScrollView{
                ForEach(viewModel.cards.reversed(), id:\.id){ card in
                    CardButtonRow(card)
                    CardDetailsContent(card)                    
                }
            }
            
        }
        .animation(.spring(), value: currentCardHolder)
        .animation(.spring(), value: viewModel.cards)
        .onReceive(viewModel.cardHolderEvent, perform: { cardHolder in
            if currentCardHolder != cardHolder{
                showRemoveButton = false
            }
            currentCardHolder = cardHolder
        })
        .onAppear{
            viewModel.handleInput(.fetchCards)
        }
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItem(placement : .navigationBarLeading) {
                Button {
                    showAddCard.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
                
            }
        }
        .sheet(isPresented: $showAddCard) {
            AddFirstCardTab(authTabSelection: .constant(AuthScreen.AuthTab.addcard)) {
                showAddCard = false
                viewModel.cards = []
                viewModel.handleInput(.fetchCards)
            }
        }
    }
    
    
    @ViewBuilder
    func CardDetailsContent(_ card : CardModel) -> some View{
        
        let showCardDetails = !currentCardHolder.cardholder.isEmpty &&
        currentCardHolder.id == card.id
        
        if showCardDetails {
            CardDetailsView(card: $currentCardHolder, isManagementCard: true)
                .onAppear{
                    showRemoveButton = true
                }
            Button {
                viewModel.handleInput(.deleteCard(card.id))
            } label: {
                Label {
                    Text("Delete card")
                } icon: {
                    Image(systemName: "trash")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .offset(x : showRemoveButton ? 0 : -800)
            .animation(.spring().delay(0.4), value: showRemoveButton)
        }
    }
    
    @ViewBuilder
    func CardButtonRow(_ card : CardModel) -> some View {
        
        let degree : Double = card.isSelected ? 90 : 0

        Button {
            viewModel.handleInput(.selectCard(card))
        } label: {
            HStack{
                Text(card.secretCardNumber4)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .rotationEffect(Angle(degrees: degree))
                
            }
            .animation(.spring(), value: card.isSelected)
            .onAppear{
                print(card.secretCardNumber4, card.isSelected)
            }
            .foregroundColor(.white)
            .padding()
            
        }
        .background(Color.white.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct CardManagementScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardManagementScreen()
            .environmentObject(CardStackViewModel())
    }
}
