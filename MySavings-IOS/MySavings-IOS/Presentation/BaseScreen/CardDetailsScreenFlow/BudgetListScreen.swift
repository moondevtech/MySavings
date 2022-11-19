//
//  BudgetListScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @Binding var newTransaction : NewTransactionModel

    @EnvironmentObject var parentViewModel : CardDetailsScreenViewModel

    var body: some View {
        VStack{
            List(parentViewModel.budgetRow, id: \.id) { row in
                Button {
                    newTransaction.budget = row.budgetDataModel.name
                    newTransaction.nextTab()
                } label: {
                    HStack{
                        Text(row.budgetDataModel.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.body.bold())
                            .padding(.horizontal, 40)
                        
                        Image(systemName: "arrow.right")
                    }
                }
            }
        }
        .onDisappear{
          //  budgetRows = .init()
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Pick a budget")
        .padding(.top, 50)
    }
    

}

struct BudgetListScreen_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListScreen(
            newTransaction: .constant(.init())
        )
        .environmentObject(CardDetailsScreenViewModel())
    }
}
