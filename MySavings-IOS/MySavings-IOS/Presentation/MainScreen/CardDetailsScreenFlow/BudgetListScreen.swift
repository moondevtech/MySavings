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
        List($parentViewModel.budgetRow, id: \.self) { $row in
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
            .offset(x: row.offset)
            .onAppear{
                let index =  parentViewModel.budgetRow.firstIndex(of: row)!
                withAnimation(.spring().delay(Double(index) * 0.2)) {
                    row.offset = 0
                }
            }
            
        }
        .navigationTitle("Pick a budget")
        .padding(.top, 50)
    }
}

struct BudgetListScreen_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListScreen(
            newTransaction: .constant(.init()))
            .environmentObject(CardDetailsScreenViewModel())
    }
}
