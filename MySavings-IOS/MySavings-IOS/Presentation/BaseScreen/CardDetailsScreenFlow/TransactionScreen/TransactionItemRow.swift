//
//  TransactionItemRow.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 17/11/2022.
//

import SwiftUI

struct TransactionItemRow: View {
    
    @Binding var screenModel : TransactionScreenModel
    @State var hasAppearedd : Bool = false
    @EnvironmentObject var parentViewModel : TransactionScreenViewModel
    
    var body: some View {
        ZStack{
            Button {
                parentViewModel.handleInput(.remove(screenModel))
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
                .opacity(hasAppearedd ? 1 : 0)
            }

            SlidingLayer()

        }
        .preferredColorScheme(.dark)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline : .now() + 0.3){
                hasAppearedd = true
            }
        }
    }
    
    @ViewBuilder
    func SlidingLayer() -> some View {
        HStack{
            Text(screenModel.transaction.transactionTitle)
                .font(.body)
            Spacer()
            Text(screenModel.transaction.amount.formatted() + "₪")
                .font(.body.bold())
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(Color.white.opacity(0.3))
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x:screenModel.slidingOffset)
        .gesture(DragGesture()
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
        )
        .simultaneousGesture(TapGesture()
            .onEnded(onTapEnded)
        )
    }
    
    private func onDragChanged( _ value : DragGesture.Value){
        let xOffset = value.translation.width
         let range = -125.0...0.0
         if range.contains(xOffset){
             if xOffset < -90 {
                 screenModel.slidingOffset = -125
             }else{
                 screenModel.slidingOffset = xOffset
             }
         }
    }
    
    private func onDragEnded( _ value : DragGesture.Value){
        if screenModel.slidingOffset > -124 {
            withAnimation(.spring()) {
                screenModel.slidingOffset = 0
            }
        }
    }
    
    private func onTapEnded(_ value : TapGesture.Value){
        withAnimation {
            screenModel.slidingOffset = 0
        }
    }
}

struct TransactionItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionItemRow(
            screenModel: .constant(.init())
        )
        .environmentObject(TransactionScreenViewModel())
    }
}
