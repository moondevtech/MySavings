//
//  PaymentHistoryScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import SwiftUI

struct PaymentHistoryScreen: View {
    
    @State var fromDate : Date = .now
    @State var toDate : Date = .now
    @State var history : [HistoryTransactionModel] = []
    @StateObject var viewModel : PaymentHistoyViewModel = .init()
    
    var body: some View {
        VStack{
            DateRangers()
            List($viewModel.tempTransactions, id: \.id) { $transaction in
                VStack{
                    
                    HStack{
                        Spacer()
                        Text(transaction.transaction.transactionDate.toDayShortFormat())
                            .font(.caption)
                            .fontWidth(.condensed)
                    }
                    .padding(.bottom, 4)

                    HStack{
                        Text(transaction.transaction.transactionTitle)
                            .font(.body.bold())
                        Spacer()
                        Text(transaction.transaction.amount.formatted(formatting:.currency))
                            .font(.body.bold())
                            .fontWidth(.condensed)
                        
                    }
                }
                .offset(x: transaction.offset)
                .onAppear{
                    withAnimation(.spring().delay(0.2)) {
                        transaction.offset = 0
                    }
                }
            }
            .refreshable {
                viewModel.handleInput(.fetchAllTransactions)
            }
            
        }
        .animation(.spring(), value: viewModel.tempTransactions)
        .onAppear{
            viewModel.handleInput(.fetchAllTransactions)
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func DateRangers() -> some View {
        VStack{
            DatePicker(selection: $fromDate, displayedComponents: .date) {
                Text("From")
                    .font(.body.bold())
                    .fontWidth(.condensed)
            }
            
            DatePicker(selection: $toDate, displayedComponents: .date) {
                Text("to")
                    .font(.body.bold())
                    .fontWidth(.condensed)
            }
        }
        .padding(.horizontal)
        .onChange(of: fromDate) { newValue in
            if newValue < toDate {
                viewModel.handleInput(.fetch(newValue...toDate))
            }
        }
        .onChange(of: toDate) { newValue in
            if newValue > fromDate {
                viewModel.handleInput(.fetch(fromDate...newValue))
            }
        }
    }
}

struct PaymentHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PaymentHistoryScreen()
        }
    }
}
