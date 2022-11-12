//
//  CardDetailsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

struct NewTransactionModel {
    var budget : String = ""
    var reason : String = ""
    var amount : String = "0.0"
    var date : Date = .now
    
    
    var realAmount : Double {
        Double(amount) ?? 0.0
    }
    
}

struct CardDetailsScreen: View {
    var id : String
    
    @State var tabTransaction : Int = 0
    @State var card : CardModel = .init(cardData: .init())
    @State var scaleEffect = 0.0
    @State var newTransaction : NewTransactionModel = .init()

    @StateObject var viewModel = CardDetailsScreenViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabTransaction) {
                BudgetAndTransactions()
                    .tag(0)
                
                BudgetList()
                    .tag(1)
                
                TransactionForm()
                    .tag(2)
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
           // .animation(.spring(), value: viewModel.transactions)
            .animation(.spring(), value : tabTransaction)
            .onReceive(viewModel.cardFoundEvent, perform: { card in
                self.card =  card
            })
            .onAppear{
                viewModel.handleInput(.fetchCard(id))
            }
            .onReceive(viewModel.transactionSavedEvents, perform: { _ in
                viewModel.handleInput(.fetchCard(id))

            })
            .toolbar {
                ToolbarItem(placement : .navigationBarLeading) {
                    Button {
                        if tabTransaction != 0 {
                            tabTransaction -= 1
                        }else{
                            tabTransaction += 1
                        }
                    } label: {
                        let image = tabTransaction == 0 ? "plus" : "arrow.left"
                        Image(systemName: image)
                            .foregroundColor(.white)
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func TransactionForm() -> some View  {
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
                viewModel.handleInput(.saveTransaction(newTransaction))
                tabTransaction = 0
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity, alignment: .center)
            }

        }
        .navigationTitle("Transaction details")
    }
    
    @ViewBuilder
    func BudgetList() -> some View  {
        List(viewModel.transactions.keys.reversed(), id: \.self) { budget in
            Button {
                newTransaction.budget = budget.name
                tabTransaction += 1
            } label: {
                HStack{
                    Text(budget.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.body.bold())
                        .padding(.horizontal, 40)
                    
                    Image(systemName: "arrow.right")
                }
            }

        }
        .navigationTitle("Pick a budget")
        .padding(.top, 50)
    }
    
    @ViewBuilder
    func Header() -> some View {
        BudgetView(cardId: id)
            .padding(.bottom, 40)
        
        CreditCardView(card: card, isNavigatable: false)
            .scaleEffect(scaleEffect)
    }
    
    
    @ViewBuilder
    func TransactionView(_ budget : BudgetDataModel) -> some View {
        if budget.isSelected{
            ForEach(Array(viewModel.transactions[budget]!), id: \.self) { transaction in
                HStack{
                    Text(transaction.transactionTitle)
                        .font(.body)
                    Spacer()
                    Text(transaction.amount.formatted() + "₪")
                        .font(.body.bold())
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.white.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    func BudgetRowButton(_ budget : BudgetDataModel) -> some View {
        Button {
            viewModel.handleInput(.selectBudget(budget))
        } label: {
            HStack{
                Text(budget.name)
                    .frame(alignment: .leading)
                    .foregroundColor(.white)
                    .font(.body.bold())
                    .padding(.horizontal, 40)
                
                Text("\(budget.realAmountSpent.formatted())/\(budget.maxAmount.formatted())")
                    .frame(alignment: .trailing)
                    .foregroundColor(.white)
                    .font(.body.bold())
                    .padding(.horizontal, 40)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
        }
    }
    
    
    @ViewBuilder
    func BudgetAndTransactions() ->some View{
        VStack{
            Header()
            ScrollView {
                VStack {
                    ForEach(viewModel.transactions.keys.reversed(), id: \.self) { budget in
                        BudgetRowButton(budget)
                        TransactionView(budget)
                    }
                }
                .padding(.top, 50)
            }
        }
        .onAppear{
            withAnimation {
                scaleEffect = 1.5
            }
        }
    }
}

struct CardDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsScreen(id: "")
    }
}
