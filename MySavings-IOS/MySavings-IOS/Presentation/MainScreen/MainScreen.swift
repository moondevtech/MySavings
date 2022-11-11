//
//  MainScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

let shekel = "₪"

enum MainViewRoutes {
    case main, management, expenses, history, settings
}

class MainRouter : ObservableObject {
    @Published var route : MainViewRoutes = .main
}

struct MainScreen: View {
    
    @StateObject var mainRouter : MainRouter = .init()
    @StateObject var viewModel : CardStackViewModel = .init()
    
    @State var showMenu : Bool = false
    @State var scaleEffect : CGFloat = 1.0
    @State var angleRotation : CGFloat = 0.0
    @State var offsetX : CGFloat = 0.0
    
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
                    Text("Management")
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
            
            ToolbarItem(placement : .navigationBarTrailing) {
                HStack{
                    MenuButtonOpener()
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
