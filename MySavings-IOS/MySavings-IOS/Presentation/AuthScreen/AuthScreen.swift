//
//  AuthScreen.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 04/11/2022.
//

import SwiftUI


struct AuthScreen: View {
    
    enum AuthTab : Int {
        case start, registration, otp ,success, addcard
        
        mutating func navigateBack(){
            switch self {
            default  :
                self = .registration
            }
        }
        
        mutating func navigateForward(){
            switch self{
            case .start:
                self = .registration
            case .registration :
                self = .otp
            case .success :
                self = .addcard
            default:
                break
            }
        }
    }
    
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var router : Router
    @State var authTabSelection : AuthTab = .start
    
    
    init(){
        UIScrollView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
       // NavigationView{
        ZStack {
            TabView(selection: $authTabSelection){
                    StartTabView(authTabselection: $authTabSelection)
                        .tag(AuthTab.start)
                    
                    RegisterTabView(authTabselection: $authTabSelection)
                        .tag(AuthTab.registration)
                        .environmentObject(authViewModel)
                    
                    OtpScreen(authTabselection:$authTabSelection)
                        .tag(AuthTab.otp)
                        .environmentObject(authViewModel)
                    
                    RegistrationSuccessTab(authTabSelection: $authTabSelection)
                        .tag(AuthTab.success)
                        .environmentObject(authViewModel)
                    
                    AddFirstCardTab(authTabSelection: $authTabSelection){
                        router.navigateToMain()
                    }
                    .tag(AuthTab.addcard)
                    .environmentObject(authViewModel)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .navigationBarBackButtonHidden()
            
            BackButton()
        }
        .animation(.spring(), value: authTabSelection)
            
    }
    
    @ViewBuilder
    func BackButton() -> some View{
        if authTabSelection == .otp {
            GeometryReader { geo in
                let frame =  geo.frame(in : .global)
                Button {
                    authTabSelection.navigateBack()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .frame( height: 40, alignment: .center)
                        .padding(.horizontal)
                }
                .frame(height: 40, alignment: .center)
                .background(.white.opacity(0.2))
                .clipShape(Capsule())
                .position(x: frame.minX + 50, y: frame.minY )
                .opacity(0.8)
            }
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
