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
            ValidationField(placeholder: "Card number" ,
                            value: $card.cardnumber,
                            check: formatCardNumber(_:))
                .padding(.bottom)
                .textContentType(.creditCardNumber)
                .submitLabel(.continue)
            
            HStack{
                ValidationField(placeholder: "CVV" ,value: $card.cvv) { input in
                    input.count == 3
                }
                .textContentType(.creditCardNumber)
                .submitLabel(.continue)
                
                ValidationField(placeholder: "Card holder" ,value: $card.cardholder,check: handleCardHolder(_:))
                .textContentType(.name)
                .submitLabel(.done)

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
    
    private func formatCardNumber(_ input : String) -> Bool{

        let (type, formatted, valid) = CardMatcher.shared.checkCardNumber(input)
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
        return valid
    }
    
    private func handleCardHolder(_ input : String) -> Bool{
        let toCheck = input.components(separatedBy: CharacterSet.decimalDigits).joined()
        return !toCheck.isEmpty && toCheck.count > 3
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsView(
            card: .constant(.init())
        )
    }
}
