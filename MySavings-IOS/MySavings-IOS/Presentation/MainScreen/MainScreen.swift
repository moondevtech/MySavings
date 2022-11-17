//
//  MainScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

let shekel = "₪"

struct NewBudgetModel {
    var reason : String = ""
    var amount : String =  ""
    var cardId : [String] = []
    var realAmount : Double {
        return Double(amount) ?? 0.0
    }
}

enum MainViewRoutes {
    case main, management, expenses, history, settings
}

class MainRouter : ObservableObject {
    @Published var route : MainViewRoutes = .main
}

struct MainScreen: View {
    
    @StateObject var mainRouter : MainRouter = .init()
    @StateObject var viewModel : CardStackViewModel = .init()
    
    @State var showAddNewBudget : Bool = false
    @State var showMenu : Bool = false
    @State var scaleEffect : CGFloat = 1.0
    @State var angleRotation : CGFloat = 0.0
    @State var offsetX : CGFloat = 0.0
    
    //budget
    @State var newBudgetModel : NewBudgetModel = .init()
    @State var tabselection : Int = 0
    @State var successScaleEffect :  CGFloat = 0.0
    @State var isSuccess :  Bool = true


    
    @EnvironmentObject var router : Router
    
    var body: some View {
        
        ZStack{
            Color.white
            
            VStack(spacing: 0){
                
                switch mainRouter.route{
                case .main :
                    BaseView()
                        .navigationBarTitle("Cards")

                case .expenses:
                    WalletView()
                        .preferredColorScheme(.dark)
                        .navigationBarTitle("Expenses")

                case .history:
                    Text("History")
                        .navigationBarTitle("History")


                case .settings:
                    Text("Settings")
                        .navigationBarTitle("Settings")

                case .management:
                    CardManagementScreen()
                        .navigationBarTitle("Management")
                }
            }
            .disabled(showMenu)
            .background(Color.black)
            .scaleEffect(scaleEffect)
            .offset(x: offsetX)
            
            if showMenu {
                MenuView(isShown: $showMenu)
                .transition(.move(edge: .leading))
                .environmentObject(mainRouter)
            }
        
        }
        .environmentObject(viewModel)
        .onChange(of: showMenu) { isShow in
            menuTransitions(isShown: isShow)
        }
        .toolbar {
            if !showMenu && mainRouter.route == .main{
                
                ToolbarItem(placement : .navigationBarLeading) {
                    Button {
                        showAddNewBudget.toggle()
                    } label: {
                        let image = "plus"
                        Image(systemName: image)
                            .foregroundColor(.white)
                    }
                    
                    
                }
            }
            
            ToolbarItem(placement : .navigationBarTrailing) {
                HStack{
                    MenuButtonOpener()
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showAddNewBudget) {
            NewBudgetFlow()
        }

    }
    
    
    @ViewBuilder
    func NewBudgetFlow() -> some View {
         NavigationView {
            TabView(selection: $tabselection) {
                NewBudgetForm()
                    .tag(0)
                
                NewBudgetCards()
                    .tag(1)
                
                ResultView()
                    .padding(.bottom, 30)
                    .scaleEffect(successScaleEffect)
                    .tag(2)
                    .onAppear{
                        withAnimation(.spring()) {
                            successScaleEffect = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline :.now() + 0.7){
                            showAddNewBudget = false
                        }
                    }
                    .onDisappear{
                        tabselection = 0
                    }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement : .navigationBarLeading) {
                    Button {
                        if tabselection != 0 {
                            withAnimation {
                                tabselection -= 1
                            }
                        }else{
                            showAddNewBudget = false
                            newBudgetModel = NewBudgetModel()
                        }
                    } label: {
                        let image = tabselection == 0 ? "xmark" : "arrow.left"
                        Image(systemName: image)
                            .foregroundColor(.white)
                    }
                    
                }
                
                ToolbarItem(placement : .principal) {
                    let title = tabselection == 0 ? "New budget" : tabselection == 1 ? "Select card" : tabselection == 2 ? "" : ""
                    Text(title)
                }
                
                if tabselection == 1 {
                    ToolbarItem(placement : .navigationBarTrailing) {
                        Button {
                            viewModel.handleInput(.newBudget(newBudgetModel))
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .onReceive(viewModel.moveToSuccess) { isSuccess in
                self.isSuccess = isSuccess
                withAnimation {
                    tabselection = 2
                }
            }
        }

    }
    
    @ViewBuilder
    func ResultView() -> some View {
        if isSuccess{
            SuccessView()
        }else{
            FailureView()
        }
    }
    
    @ViewBuilder
    func NewBudgetCards() -> some View {
        
        List(viewModel.cards, id:\.id) { card in
            Button {
                viewModel.handleInput(.selectCard(card))
                if card.isSelected{
                    if let index = newBudgetModel.cardId.firstIndex(of: card.id){
                        newBudgetModel.cardId.remove(at: index)
                    }
                }else{
                    newBudgetModel.cardId.append(card.id)
                }
            } label: {
                HStack{
                    let imageSelected = card.isSelected ? "checkmark" : "circle.dotted"
                    Text(card.cardData.cardNumber)
                    Spacer()
                    Image(systemName: imageSelected)
                }
                .foregroundColor(.white)
            }

        }
    }
    
    @ViewBuilder
    func NewBudgetForm() -> some View {
        Form {
            Section(header : Text("Budget name")) {
                TextField("", text: $newBudgetModel.reason)
            }
            
            Section(header : Text("Amount")) {
                TextField("", text: $newBudgetModel.amount)
                    .keyboardType(.numberPad)
            }
            
            Button {
                withAnimation {
                    tabselection = 1
                }
            } label: {
                HStack{
                    Spacer()
                    Text("Add to card")
                    Spacer()
                }
            }

        }
    }
    
    
    @ViewBuilder
    func BaseView() -> some View {
            VStack{
                BudgetView()
                Spacer()
                CardStackView()
            }
    }
    
    @ViewBuilder
    func MenuButtonOpener() -> some View{
        Button {
            withAnimation(.spring()) {
                showMenu.toggle()
            }
        } label: {
            VStack{
                Rectangle()
                    .frame(width: 30, height:1)
                Rectangle()
                    .frame(width: 30, height:1)
                Rectangle()
                    .frame(width: 30, height:1)
            }
            .foregroundColor(.white)
            .rotationEffect(Angle(degrees: angleRotation))
        }
        .padding()
    }
    
    
    private func menuTransitions(isShown : Bool){
        withAnimation(.spring()) {
            scaleEffect = isShown ? 0.8 : 1.0
            angleRotation = isShown ? -90 : 0
            offsetX = isShown ? 100 : 0
        }
    }
    


}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(Router())
    }
}
