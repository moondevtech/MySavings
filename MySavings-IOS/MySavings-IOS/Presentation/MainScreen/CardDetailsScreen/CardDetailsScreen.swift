//
//  CardDetailsScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine


struct BudgetRowModel: Identifiable, Hashable, Equatable {
    var id : String =  UUID().uuidString
    var budgetDataModel : BudgetDataModel
    var isSelected : Bool = false
    var offset : CGFloat = -100
}

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
        List($viewModel.budgetRow, id: \.self) { $row in
            Button {
                newTransaction.budget = row.budgetDataModel.name
                tabTransaction += 1
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
                let index =  viewModel.budgetRow.firstIndex(of: row)!
                withAnimation(.spring().delay(Double(index) * 0.2)) {
                    row.offset = 0
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
    func TransactionView(row : BudgetRowModel) -> some View {
        //if row.budgetDataModel.isSelected{
        ForEach(Array(viewModel.transactions[row.budgetDataModel]!), id: \.self) { transaction in
            TransactionItemRow(transaction: transaction)
        }
        // }
    }
    
    @ViewBuilder
    func BudgetRowButton(_ row : Binding<BudgetRowModel>) -> some View {
        ZStack{
            if let transactions =  row.wrappedValue.budgetDataModel.transactions,
               !transactions.isEmpty{
                NavigationLink {
                    TransactionView(row: row.wrappedValue)
                        .padding(.horizontal)
                        .navigationTitle(row.wrappedValue.budgetDataModel.name)
                } label: {
                    RowBudgetButton(row.wrappedValue.budgetDataModel, isLink: true)
                }
            }else{
                RowBudgetButton(row.wrappedValue.budgetDataModel)
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
    
    @ViewBuilder
    func BudgetAndTransactions() ->some View{
        VStack{
            Header()
            ScrollView {
                ForEach($viewModel.budgetRow, id: \.self) { $row in
                    BudgetRowButton($row)
//                        .offset(x: row.offset)
//                        .onAppear{
//                           let index =  viewModel.budgetRow.firstIndex(of: row) ?? 0
//                           withAnimation(.spring().delay(Double(index) * 0.2 + 0.5)) {
//                                row.offset = 0
//                            }
//                        }
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
