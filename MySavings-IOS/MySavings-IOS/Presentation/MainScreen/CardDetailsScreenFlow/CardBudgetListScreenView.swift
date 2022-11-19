//
//  CardBudgetListView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct CardBudgetListScreenView<Header> : View where Header :  View {
    
    @ViewBuilder
    var header : () -> Header
    
    @EnvironmentObject var parentViewModel : CardDetailsScreenViewModel
    
    var body: some View {
        VStack{
            header()
            ScrollView {
                ForEach(parentViewModel.budgetRow, id: \.self) { row in
                    BudgetRowButton(row)
                }
                .padding(.top, 50)
            }
        }
    }
    
    
    @ViewBuilder
    func BudgetRowButton(_ row : BudgetRowModel) -> some View {
        ZStack{
            if let transactions =  row.budgetDataModel.transactions,
               !transactions.isEmpty{
                NavigationLink {
                    TransactionsScreen(
                        transactions: Array(parentViewModel.transactions[row.budgetDataModel]!)
                    )
                    .padding(.horizontal)
                    .navigationTitle(row.budgetDataModel.name)
                } label: {
                    RowBudgetButton(row.budgetDataModel, isLink: true)
                }
            }else{
                RowBudgetButton(row.budgetDataModel)
            }
        }
        
    }
    
    @ViewBuilder
    func RowBudgetButton(_ budgetDataModel : BudgetDataModel, isLink : Bool  = false) -> some View {
        HStack{
            Text(budgetDataModel.name)
                .frame(alignment: .leading)
                .foregroundColor(.white)
                .font(.body.bold())
                .padding(.horizontal, 40)
            
            Text("\(budgetDataModel.realAmountSpent.formatted())/\(budgetDataModel.maxAmount.formatted())")
                .frame(alignment: .trailing)
                .foregroundColor(.white)
                .font(.body.bold())
                .padding(.horizontal, 40)
            
            Spacer()
            
            
            if isLink {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(Capsule())
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
        
    }
}

struct CardBudgetListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CardBudgetListScreenView<Text>(header : {
            Text("Hello")
        })
        .environmentObject(CardDetailsScreenViewModel())
    }
}
