//
//  BudgetView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct BudgetView: View {
    @StateObject var viewModel : BudgetViewVM = .init()
    
    var cardId : String = ""
    
    var body: some View {
        Button {
            viewModel.handleInput(.toggleDisplay)
        } label: {
            ZStack{
                GeometryReader{ geo in
                    let frame = geo.frame(in: .local)
                    Color.green
                        .frame(width: viewModel.percentSpent * frame.width / 100)
                }
                .background(Color.white.opacity(0.1))
                .overlay(
                    Rectangle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.white.opacity(0.3))
                )

                BudgetDisplayView()
            }
        }
        .frame(height: 40)
        .padding()
        .animation(.spring(), value: viewModel.percentSpent)
        .preferredColorScheme(.dark)
        .onAppear{
           handleBudgetFetching()
        }
    }
    
    private func handleBudgetFetching(){
        if cardId.isEmpty{
            viewModel.handleInput(.fetchBudget)
        }else{
            viewModel.handleInput(.fetchBudgetByCardId(cardId))
        }
    }
    
    @ViewBuilder
    func BudgetDisplayView() -> some View {
        if viewModel.budgetDisplayType == .percentType {
            PercentDisplay()
        }else {
           AmountDisplay()
        }
    }
    
    
    @ViewBuilder
    func PercentDisplay() -> some View {
        Text("\(viewModel.percentSpent.formatted(formatting: .percent))")
            .font(.title.bold())
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    func AmountDisplay() -> some View {
        Text("\(viewModel.amounSpent.formatted())/\(viewModel.amountAllocated.formatted(formatting: .currency))")
            .font(.title.bold())
            .foregroundColor(.white)
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
    }
}
