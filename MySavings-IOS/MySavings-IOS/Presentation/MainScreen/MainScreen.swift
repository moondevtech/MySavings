//
//  MainScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import SwiftUI
import Combine

let shekel = "₪"

struct MainScreen: View {
    
    @StateObject var viewModel : CardStackViewModel = .init()
    
    @State var showMenu : Bool = false
    @State var scaleEffect : CGFloat = 1.0
    @State var angleRotation : CGFloat = 0.0
    @State var offsetX : CGFloat = 0.0
    
    var body: some View {
        ZStack{
            Color.white
            
            ZStack {
                VStack{
                    HStack{
                        MenuButtonOpener()
                        Spacer()

                    }
                    BudgetView()
                    Spacer()
                    CardStackView()
                    
                }
                .disabled(showMenu)
                .background(Color.black)
                .scaleEffect(scaleEffect)
                .rotation3DEffect(Angle(degrees: angleRotation), axis: (0,0.5,0))
                .offset(x: offsetX)
                if showMenu {
                    Color.white.opacity(0.4)
                }
            }
            
            if showMenu {
                MenuView(isShown: $showMenu)
                .transition(.move(edge: .leading))
            }
            
        }
        .onChange(of: showMenu) { isShow in
            menuTransitions(isShown: isShow)
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
        }
        .padding()
    }
    
    
    private func menuTransitions(isShown : Bool){
        withAnimation(.spring()) {
            scaleEffect = isShown ? 0.8 : 1.0
          //  angleRotation = isShown ? -60 : 0
            offsetX = isShown ? 100 : 0
        }
    }
    


}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
