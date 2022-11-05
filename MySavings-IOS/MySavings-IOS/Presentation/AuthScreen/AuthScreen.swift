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
    
    
    @State var tabSelection : Int = 1
    

    
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
                StartTabView(tabSelection: $tabSelection)
                    .tag(1)

                
                RegisterTabView(tabSelection: $tabSelection)
                    .tag(2)

                RegistrationSuccessTab(tabSelection: $tabSelection)
                    .tag(3)
                
                AddFirstCardTab(tabSelection: $tabSelection)
                    .tag(4)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarBackButtonHidden()
            
        }

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
