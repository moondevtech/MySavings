//
//  AuthScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 04/11/2022.
//

import SwiftUI


struct AuthBudget : Identifiable , Hashable {
    var id : String =  UUID().description
    var title : String = "..."
    var amount : String = "\(0.0)"
    
    func realAmount() -> Double{
        Double(amount) ?? 0.0
    }
    
    func isEmpty() -> Bool{
        amount == "0.0" || title ==  "..."
    }
}

struct AuthBudgets : Identifiable {
    var id : String =  UUID().description
    var budgets : [AuthBudget] = .init()
    var tempBudgets : [AuthBudget] = .init()

    
    var savable : Bool {
        tempBudgets.count > 0 &&
        tempBudgets.map{$0.isEmpty()}.contains{$0 == false}
    }
    
}

struct CardHolder : Identifiable, Equatable {
    
    var id =  UUID().uuidString
    var cardnumber : String = ""
    var cardholder : String = ""
    var cvv : String = ""
    var expirationDate : Date = .now
    var accountNumber : Date = .now
}

struct AuthScreen: View {
    
    
    @State var tabSelection : Int = 4
    
    //
    @State var firstTabXOffset : CGFloat = -400
    
    //register
    @State var secondTabAppeared : Bool = false
    @State var userName : String = ""
    @State var password : String = ""
    @State var secondTabOffset : CGFloat = -400
    
    //success
    @State var imageScale : CGFloat =  0.0
    @State var successTabOffset : CGFloat = -400
    
    //creditcard
    @State var card : CardHolder = .init()
    @State var addCardOffset : CGFloat = -400
    @State var isAddingBudgets : Bool = false
    @State var canAddBudget : Bool = false
    @State var addedBudgets : AuthBudgets = .init()
    @State var listHeight : CGFloat = 140
    
    
    init(){
        UIScrollView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
        NavigationView{
            TabView(selection: $tabSelection){
                StartTab()
                    .tag(1)
                    .onAppear{
                        firstTabXOffset = 0
                    }
                
                RegisterTab()
                    .tag(2)
                    .onAppear{
                        secondTabOffset = 0
                    }
                
                RegistrationSuccess()
                    .tag(3)
                    .onAppear{
                        successTabOffset = 0
                        imageScale = 1.0
                    }
                
                AddCardWishTab()
                    .tag(4)
                    .onAppear{
                        addCardOffset = 0
                    }
                    .animation(.spring().delay(0.8), value: addCardOffset)
                    .animation(.spring(), value: isAddingBudgets)
                    .animation(.spring(), value: canAddBudget)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarBackButtonHidden()
            
        }
        
        
        
    }
    
    
    
    @ViewBuilder
    private func AddCardWishTab() -> some View{
                
            VStack{
                
                TitleTab("Credit Card ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 80)
                    .offset(x: addCardOffset)
                    .animation(.spring().delay(0.2), value: addCardOffset)
                
                
                
                VStack{
                    TextField("Card number", text: $card.cardnumber)
                        .padding(.bottom)
                        .textContentType(.creditCardNumber)
                    HStack{
                        TextField("CVV", text: $card.cvv)
                        TextField("Card holder", text: $card.cardholder)
                            .textContentType(.creditCardNumber)
                    }
                    .padding(.bottom)
                    
                    DatePicker(selection: $card.expirationDate, in: Date.now...Date.distantFuture , displayedComponents: .date) {
                        Text("Expired")
                    }
                    .datePickerStyle(.automatic)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .offset(x: addCardOffset)
                .animation(.spring().delay(0.4), value: addCardOffset)
                .padding()
                .onChange(of: card) { newValue in
                    canAddBudget =  !newValue.cardnumber.isEmpty && !newValue.cvv.isEmpty && !newValue.cardholder.isEmpty
                }
                
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
                
                let addBudgetTitle = addedBudgets.budgets.count > 0 ? "Edit" : "Add Budget ..."
                        
                
                if canAddBudget {
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

                
                LetsGoButton("Save the card !") {
                    
                }
                .offset(x: addCardOffset)
                .preferredColorScheme(.dark)
                
                Spacer()
            }
            .sheet(isPresented: $isAddingBudgets, onDismiss: {
                checkTempBudgets()
            }) {

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
            }
    }
    
    
    private func checkTempBudgets(){
        let toAdd =  addedBudgets.tempBudgets.filter { !$0.isEmpty() }
        
        addedBudgets.budgets = toAdd
        
        addedBudgets.tempBudgets = addedBudgets.tempBudgets.filter{!$0.isEmpty()}

    }
    
    @ViewBuilder
    private func RegistrationSuccess() -> some View{
        VStack{
            ZStack{
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 200)
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
            .scaleEffect(imageScale)
            .animation(.spring().delay(0.4), value: imageScale)
            
            HStack(spacing: 50){
                LetsGoButton("Add a card ?") {
                    withAnimation{
                        tabSelection = 4
                    }
                }
                
                LetsGoButton("Skip") {
                    //Reach main app
                }
            }
            .offset(x: successTabOffset)
            .animation(.spring().delay(0.2), value: successTabOffset)
        }
        .preferredColorScheme(.dark)
        
    }
    
    @ViewBuilder
    private func RegisterTab() -> some View {
        VStack{
            TitleTab("About you")
                .padding(.top, 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: secondTabOffset)
                .animation(.spring().delay(0.2), value: secondTabOffset)
            
            Spacer()
            
            VStack{
                Text("Username")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body.bold())
                    .foregroundColor(.black)
                
                TextField("Here...", text: $userName)
                    .textFieldStyle(.roundedBorder)
                    .background(Color.white)
                    .foregroundColor(.white)
                
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .offset(x: secondTabOffset)
            .animation(.spring().delay(0.4), value: secondTabOffset)
            
            
            
            VStack{
                Text("Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body.bold())
                    .foregroundColor(.black)
                
                TextField("Here...", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.white)
                
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 40)
            .offset(x: secondTabOffset)
            .animation(.spring().delay(0.6), value: secondTabOffset)
            
            
            
            Spacer()
            
            
            LetsGoButton("Done !"){
                //save user
                withAnimation{
                    tabSelection = 3
                }
            }
            .padding(.bottom, 80)
            .offset(x: secondTabOffset)
            .animation(.spring().delay(0.8), value: secondTabOffset)
            
            
        }
        .padding()
        .preferredColorScheme(.dark)
        
    }
    
    @ViewBuilder
    private func StartTab() -> some View{
        VStack{
            TitleTab("Start saving money !")
                .offset(x: firstTabXOffset)
                .animation(.spring().delay(0.3),value: firstTabXOffset)
            
            LetsGoButton("Let's go!"){
                withAnimation(.spring()){
                    tabSelection = 2
                }
            }
            .offset(x: firstTabXOffset)
            .animation(.spring().delay(0.6), value: firstTabXOffset)
            
        }
        .preferredColorScheme(.dark)
    }
    
    
    @ViewBuilder
    private func TitleTab(_ content : String) -> some View{
        Text(content)
            .font(.title.bold())
            .foregroundColor(.white)
    }
    
    
    @ViewBuilder
    private func LetsGoButton(_ title : String, action : @escaping () -> Void) -> some View{
        Button(action: {
            action()
        }, label: {
            Text(title)
                .padding(.horizontal)
        })
        .foregroundColor(.black)
        .font(.body.bold())
        .frame(height: 60)
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.top, 40)
    }
}



class AuthScreenViewModel : ObservableObject {
    
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen()
    }
}


struct DisableScrolling: ViewModifier {
    var disabled: Bool
    
    func body(content: Content) -> some View {
        
        if disabled {
            content
                .simultaneousGesture(DragGesture(minimumDistance: 0), including: .all)
        } else {
            content
        }
        
    }
}
extension View {
    func disableScrolling(disabled: Bool) -> some View {
        modifier(DisableScrolling(disabled: disabled))
    }
}
