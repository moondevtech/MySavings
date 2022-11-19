//
//  NewTransactionFormScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct NewTransactionFormScreen: View {
    
    @Binding var newTransaction : NewTransactionModel

    @EnvironmentObject var parentViewModel : CardDetailsScreenViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Reason")){
                TextField("", text: $newTransaction.reason)
            }
            
            Section(header: Text("Amount")){
                TextField("", text: $newTransaction.amount)
                    .keyboardType(.numberPad)
            }
            
            Section (header : Text("Date")){
                DatePicker(selection:$newTransaction.date, in: Date.now...Date.distantFuture , displayedComponents: .date) {
                    Text("Transaction date:")
                }
                .datePickerStyle(.automatic)
            }
            
            Button {
                hideKeyboard()
                parentViewModel.handleInput(.saveTransaction(newTransaction))
                newTransaction.tabTransaction = 0
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .navigationTitle("Transaction details")
    }
}

struct NewTransactionFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionFormScreen(
            newTransaction: .constant(.init()))
            .environmentObject(CardDetailsScreenViewModel())
    }
}
