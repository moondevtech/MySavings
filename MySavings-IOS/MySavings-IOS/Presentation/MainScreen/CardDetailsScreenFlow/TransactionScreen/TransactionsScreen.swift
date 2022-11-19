//
//  TransactionsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import SwiftUI

struct TransactionsScreen: View {
    
    var transactions : [TransactionDataModel]
    
    var body: some View {
        ForEach(transactions, id: \.id) { transaction in
            TransactionItemRow(transaction: transaction)
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
