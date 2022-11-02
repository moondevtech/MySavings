//
//  SelectedCardView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import SwiftUI

struct SelectedCardView: View {
    
    var card : CardModel
    @State var scaleEffect : CGFloat = 0.0
    @EnvironmentObject var viewModel : WalletViewModel
    
    var body: some View {
        VStack{
            CreditCardView(card: card)
                .scaleEffect(scaleEffect)
                .id(2)
                .onTapGesture {
                    viewModel.unselectCar()
                }

            VStack {
                ForEach(viewModel.selectedCardTransactions, id: \.self) { transaction in
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
        .onAppear{
            withAnimation {
                scaleEffect = 1.5
            }
        }
        .transition(.scale)
        .padding(.top, 80 )
    }
}

struct SelectedCardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedCardView(card: .init(cardData: .init()))
            .environmentObject(WalletViewModel())
    }
}
