//
//  AddFirstCardTab.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct AddFirstCardTab: View {

    @Binding var authTabSelection : AuthScreen.AuthTab
    var onCardAdded : () -> Void
    //creditcard
    @State var card : CardHolder = .init()
    @State var addCardOffset : CGFloat = -400
    @State var isAddingBudgets : Bool = false
    @State var canAddBudget : Bool = false
    @State var addedBudgets : AuthBudgets = .init()
    @State var listHeight : CGFloat = 140
    
    @StateObject var viewModel : FirstCardViewModel = .init()
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var router : Router
    
    init(authTabSelection : Binding<AuthScreen.AuthTab>, onCardAdded : @escaping ()->Void) {
        _authTabSelection = authTabSelection
        self.onCardAdded = onCardAdded
    }
    
    var body: some View {
        VStack{
            TitleTab(content: "Credit Card ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 80)
                .offset(x: addCardOffset)
                .animation(.spring().delay(0.2), value: addCardOffset)
            
            
            CardDetailsView(card: $card)
            
            AddedBudgetList()
            
            AddBudgetButton()

            LetsGoButton(title: "Save the card !") {
                viewModel.handleInput(.addCard(card, addedBudgets))
            }
            .offset(x: addCardOffset)
            .preferredColorScheme(.dark)
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(viewModel.addCardRegistrationComplete){isComplete in
            if isComplete{
                onCardAdded()
            }
        }
        .onAppear{
            addCardOffset = 0
        }
        .animation(.spring().delay(0.8), value: addCardOffset)
        .animation(.spring(), value: isAddingBudgets)
        .animation(.spring(), value: canAddBudget)
        .sheet(isPresented: $isAddingBudgets, onDismiss: {
            checkTempBudgets()
        }) {
            BudgetListFirstCard(addedBudgets: $addedBudgets, isAddingBudgets: $isAddingBudgets)
        }
    }
    
    @ViewBuilder
    private func AddBudgetButton() -> some View{
        let addBudgetTitle = addedBudgets.budgets.count > 0 ? "Edit" : "Add Budget ..."
        if card.isReady {
            Button(addBudgetTitle) {
                isAddingBudgets = true
                if addedBudgets.tempBudgets.count < 1 {
                    addedBudgets.tempBudgets.append(.init())
                    
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top, 40)
            .transition(.scale)
        }
    }
    
    
    @ViewBuilder
    private func AddedBudgetList() -> some View {
        if !addedBudgets.budgets.isEmpty{
            ScrollView(.horizontal){
                HStack{
                    ForEach(addedBudgets.budgets, id: \.id) { budget in
                        VStack{
                            Label(budget.title, systemImage: "arrow.forward")
                            Label(budget.amount, systemImage: "dollarsign.circle")
                        }
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    }
                }
            }
        }
    }
    
    private func checkTempBudgets(){
        let toAdd =  addedBudgets.tempBudgets.filter { !$0.isEmpty() }
        
        addedBudgets.budgets = toAdd
        
        addedBudgets.tempBudgets = addedBudgets.tempBudgets.filter{!$0.isEmpty()}

    }
}

struct AddFirstCardTab_Previews: PreviewProvider {
    static var previews: some View {
        AddFirstCardTab(authTabSelection: .constant(AuthScreen.AuthTab.addcard)){
            print("card added")
        }
            .environmentObject(AuthViewModel())
            .environmentObject(Router())
    }
}
