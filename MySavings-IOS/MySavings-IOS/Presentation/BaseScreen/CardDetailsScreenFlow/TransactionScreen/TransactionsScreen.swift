//
//  TransactionsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct TransactionsScreen: View {
    
    var transactions : [TransactionDataModel]
    @State var trasactionDataModel :  [TransactionScreenModel] = .init()
    @StateObject var viewModel : TransactionScreenViewModel = .init()
    
    var body: some View {
        VStack{
            ForEach($trasactionDataModel, id: \.id) { $transaction in
                TransactionItemRow(screenModel: $transaction)
                    .offset(x: $transaction.wrappedValue.offset)
                    .onAppear{
                        $transaction.wrappedValue.offset = 0
                    }
                    .environmentObject(viewModel)
            }
            Spacer()
        }
        .redacted(reason: trasactionDataModel.isEmpty ? .placeholder : [])
        .animation(.spring(), value: trasactionDataModel)
        .onAppear{
            viewModel.handleInput(.start(transactions))
        }
        .onReceive(viewModel.screenModelReceived, perform: receivedScreenModel)
        .onReceive(viewModel.removedScreenModel, perform: removedScreenModel)
        .onDisappear{
            trasactionDataModel = .init()
        }
    }
    
    private func removedScreenModel(_ removed : TransactionScreenModel){
        if let index = trasactionDataModel.firstIndex(where: {$0.transaction == removed.transaction}){
            trasactionDataModel.remove(at: index)
        }
    }
    
    private func receivedScreenModel(_ received : TransactionScreenModel){
        if !trasactionDataModel.contains(where: {$0.id ==  received.id}){
            trasactionDataModel.insert(received, at: 0)
        }
    }
}




struct TransactionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsScreen(
            transactions: .init(arrayLiteral: .init(
                id: "1",
                amount: 300,
                transactionData: .init(),
                transactionTitle: "Food"))
        )
    }
}
