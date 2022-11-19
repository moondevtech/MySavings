//
//  TransactionItemRow.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 17/11/2022.
//

import SwiftUI

struct TransactionItemRow: View {
    
    var transaction : TransactionDataModel
    @State var offset : CGSize = .zero
    var body: some View {
        ZStack{
            
            
            Button {
                
            } label: {
                HStack{
                    Spacer()
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .frame(width: 300, height: 50, alignment: .trailing)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            SlidingLayer()

        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func SlidingLayer() -> some View {
        HStack{
            Text(transaction.transactionTitle)
                .font(.body)
            Spacer()
            Text(transaction.amount.formatted() + "₪")
                .font(.body.bold())
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(Color.white.opacity(0.3))
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(offset)
        .gesture(DragGesture()
            .onChanged({ drag in
               let xOffset = drag.translation.width
                let range = -150.0...0.0
                if range.contains(xOffset){
                    offset.width = xOffset
                }
            })
            .onEnded({ drag in
                let xOffset = drag.translation.width
                if xOffset > -150 {
                    withAnimation(.spring()) {
                        offset.width = 0
                    }
                }
            })
        )
        .simultaneousGesture(TapGesture()
            .onEnded({ _ in
                withAnimation {
                    offset.width = 0
                }
            }))
    }
}

struct TransactionItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemRow(
            transaction: .init(id: "111", amount: 2000, transactionData: .now, transactionTitle: "Pikachu")
        )
    }
}
