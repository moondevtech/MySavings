//
//  CardDetailsView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 08/11/2022.
//

import SwiftUI

struct CardDetailsView: View {
    
    @Binding var card : CardHolder
    @State var addCardOffset : CGFloat = -800

    
    var body: some View {
        VStack{
            TextField("Card number", text: $card.cardnumber)
                .padding(.bottom)
                .textContentType(.creditCardNumber)
                .submitLabel(.continue)
                .onSubmit {
                    formatCardNumber()
                }
            
            HStack{
                TextField("CVV", text: $card.cvv)
                    .textContentType(.creditCardNumber)
                    .submitLabel(.continue)


                TextField("Card holder", text: $card.cardholder)
                    .textContentType(.name)
                    .submitLabel(.continue)
            }
            .padding(.bottom)
            
            DatePicker(selection: $card.expirationDate, in: Date.now...Date.distantFuture , displayedComponents: .date) {
                Text("Expired")
            }
            .datePickerStyle(.automatic)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .offset(x: addCardOffset)
        .animation(.spring().delay(0.6), value: addCardOffset)
        .padding()
        .preferredColorScheme(.dark)
        .onAppear{
            addCardOffset = 0
        }
    }
    
    private func formatCardNumber(){

        let (type, formatted, valid) = CardMatcher.shared.checkCardNumber(card.cardnumber)
        Log.i(content:
        """
            cardtype : \(type),
            cardNumber : \(formatted),
            valid : \(valid)
        """
        )
        
        card.cardType =  type
        card.cardnumber = formatted
        card.isValid = valid        
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsView(
            card: .constant(.init())
        )
    }
}
