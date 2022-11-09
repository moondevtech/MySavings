//
//  BudgetView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI

struct BudgetView: View {
    @StateObject var viewModel : BudgetViewVM = .init()
    
    var body: some View {
        Button {
            viewModel.handleInput(.toggleDisplay)
        } label: {
            ZStack{
                GeometryReader{ geo in
                    let frame = geo.frame(in: .local)
                    Color.green
                        .frame(width: viewModel.percentSpent * frame.width / 100)
                    
                    Capsule()
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 50, height: 10)
                        .position(x: frame.width * 0.9 , y : frame.height * 0.8)
                }
                .background(Color.red)
                
                BudgetDisplayView()
            }
        }
        .frame(height: 50)
        .clipShape(Capsule())
        .padding()
        .animation(.spring(), value: viewModel.percentSpent)
        .preferredColorScheme(.dark)
        .onAppear{
            viewModel.handleInput(.fetchBudget)
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
