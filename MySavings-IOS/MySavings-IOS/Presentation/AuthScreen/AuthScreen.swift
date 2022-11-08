//
//  AuthScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 04/11/2022.
//

import SwiftUI

struct AuthScreen: View {
    
    enum AuthTab {
        case start, registration, success, addcard
    }
    
    
    @State var tabSelection : Int = 1
    @EnvironmentObject var authViewModel : AuthViewModel

        
    init(){
        UIScrollView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
        NavigationView{
            TabView(selection: $tabSelection){
                StartTabView(tabSelection: $tabSelection)
                    .tag(1)
                    .onAppear{
                        print(tabSelection)
                    }

                RegisterTabView(tabSelection: $tabSelection)
                    .tag(2)
                    .environmentObject(authViewModel)
                    .onAppear{
                        print(tabSelection)
                    }

                RegistrationSuccessTab(tabSelection: $tabSelection)
                    .tag(3)
                    .environmentObject(authViewModel)
                    .onAppear{
                        print(tabSelection)
                    }
                
                AddFirstCardTab(tabSelection: $tabSelection)
                    .tag(4)
                    .environmentObject(authViewModel)
                    .onAppear{
                        print(tabSelection)
                    }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarBackButtonHidden()
            
        }
    }
    
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen()
            .environmentObject(AuthViewModel())
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
