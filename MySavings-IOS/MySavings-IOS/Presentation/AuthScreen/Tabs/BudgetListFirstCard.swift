//
//  BudgetList.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct BudgetListFirstCard: View {
    
    @Binding var addedBudgets : AuthBudgets
    @Binding var isAddingBudgets : Bool
    
    var body: some View {
        VStack {
            
            Text("Budgets")
                    .font(.title.bold())
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding(.top, 80)
            Spacer()
            
            ScrollViewReader { reader in
                                                
                    List {
                        ForEach($addedBudgets.tempBudgets, id: \.id) { budget in
                            VStack{
                                HStack{
                                    Text("Reason")
                                        .font(.body.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    TextField(budget.title.wrappedValue, text: budget.title)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.body)
                                }
                                
                                HStack{
                                    Text("Amount")
                                        .font(.body.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    TextField("\(budget.amount.wrappedValue)", text: budget.amount)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.body)
                                }
                            }
                            .id(budget.id)
                        }
                        .onDelete { indexSet in
                            addedBudgets.tempBudgets.remove(atOffsets: indexSet)
                        }
                        
                        
                        Button("Add Budget ...") {
                            isAddingBudgets = true
                                addedBudgets.tempBudgets.append(.init())
                            reader.scrollTo(addedBudgets.tempBudgets.last?.id, anchor: .bottom)

                        }
                        
                        if addedBudgets.savable  {
                            Button("Finished") {
                                isAddingBudgets = false
                            }
                        }
                    
                    }
                    .scrollContentBackground(.hidden)
                    
            }
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

struct BudgetListFirstCard_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListFirstCard( addedBudgets: .constant(.init()), isAddingBudgets: .constant(true))
    }
}
