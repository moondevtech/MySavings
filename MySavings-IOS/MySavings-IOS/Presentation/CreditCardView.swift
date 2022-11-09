//
//  CreditCardView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI

struct CreditCardView: View {
    
    @State var rotation : CGFloat = 0
    @State var isSelected : Bool = false
    @State var offset : CGSize = .zero
    @State var selectionScale : CGFloat = 1.0
    
    @EnvironmentObject var parentViewModel : CardStackViewModel
    
    var card : CardModel
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
            
            GeometryReader { geo in
                
                let frame = geo.frame(in: .local)
                
                HapoalimRectangle()
                    .position(
                        x:frame.width * 0.3,
                        y: frame.height / 2
                    )
                
                ChipView()
                    .frame(width: 30, height: 20)
                    .position(
                        x:frame.width * 0.15,
                        y: frame.height / 2.2
                    )
                
                Text(card.cardNumber)
                    .font(.body)
                    .position(
                        x: frame.width / 2,
                        y : frame.height * 0.60
                    )
                    
                
                Text(card.date)
                    .font(.caption)
                    .position(
                        x: frame.width / 2,
                        y : frame.height * 0.74
                    )
                
                
                VStack{
                    Text(card.name)
                        .frame(width: 100, alignment: .leading)
                        .font(.caption)
                    
                    
                    Text(card.accountNumber)
                        .frame(width: 100, alignment: .leading)
                        .font(.caption)
                }
                .frame(width: 100)
                .position(
                    x: frame.width / 3.0,
                    y : frame.height * 0.85
                )
                
                MasterCardView()
                    .scaleEffect(0.3)
                    .position(
                        x: frame.width * 0.85,
                        y: frame.height * 0.85
                    )
                
                
            }
            .frame(width: 240, height: 150)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 1).foregroundColor(.gray)
        )
        .foregroundColor(.black)
        .rotationEffect(Angle(degrees: rotation))
        .animation(.linear, value: rotation)
        .frame(width: 240, height: 150)
        .scaleEffect(selectionScale)
        .offset(offset)
        .zIndex(card.isSelected ? 20 : 0)
        .animation(.spring(), value: selectionScale)
        .onTapGesture {
            handleScaleAnimation()
        }

    }
    
    
    private func handleScaleAnimation(){
        selectionScale = 0.9
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            selectionScale = 1
        }
        parentViewModel.handleInput(.toCardDetails(card))
    }
    
    func toggleRotation(){
        rotation = rotation == 90 ? 0 : 90
    }
    
    
    @ViewBuilder
    func HapoalimRectangle() -> some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.red)
            .frame(width: 80, height: 80)
            .rotationEffect(.degrees(45))
    }
    
    @ViewBuilder
    func ChipView() -> some View{
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(.yellow)
        
    }
    
    @ViewBuilder
    func MasterCardView() -> some View {
        GeometryReader { geo in
            
            let frame = geo.frame(in: .local)
            
            Circle()
                .foregroundColor(.red)
                .position(x: frame.width / 2, y : frame.height / 2)
            
            
            Circle()
                .foregroundColor(.orange.opacity(0.5))
                .position(x: frame.width , y : frame.height / 2)
            
        }
        .frame(width: 100, height: 100)
    }
}



struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardView(card:
                        CardModel(
                            cardData: .init())
        )
        .environmentObject(CardStackViewModel())
    }
}
