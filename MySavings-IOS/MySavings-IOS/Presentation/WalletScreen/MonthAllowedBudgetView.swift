//
//  MonthAllowedBudgetView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 02/11/2022.
//

import SwiftUI

struct MonthAllowedBudgetView: View {
    
    @EnvironmentObject var viewModel : WalletViewModel
    
    var body: some View {
        let foregroundColor : Color = viewModel.budgetLeft.isPositive() ? Color.green : Color.red
        ZStack{
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white.opacity(0.3))
            
            Text("\(viewModel.budgetLeft.formatted()) ₪")
                .font(.title.bold())
                .foregroundColor(foregroundColor)
        }
        .padding(30)
    }
}

struct MonthAllowedBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        MonthAllowedBudgetView()
            .environmentObject(WalletViewModel())
    }
}
