//
//  MenuView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import SwiftUI

struct MenuItems : Identifiable , Hashable {
    var id : String =  UUID().uuidString
    var name : String
    var label : String
    var direction : MainViewRoutes
    var offset : CGFloat = -800
    var width : CGFloat = 0
    
}

struct MenuView: View {
    
    @State var menuItems : [MenuItems] = .init(arrayLiteral:
    MenuItems(name: "Home", label: "house", direction: .main),
    MenuItems(name: "Card management", label: "signature", direction: .management),
    MenuItems(name: "Expenses", label: "lines.measurement.horizontal", direction: .expenses),
    MenuItems(name: "History", label: "book", direction: .history),
    MenuItems(name: "Settings", label: "wrench.and.screwdriver", direction: .settings)
    )
    
    @Binding var isShown : Bool
    
    @EnvironmentObject var mainRouter : MainRouter
    
    var body: some View {
        GeometryReader { geo in
            let frame = geo.frame(in: .global)
            let viewWidth = frame.width * 0.75
            ZStack{
                Color.black
                VStack{
                    VStack{
                        ForEach($menuItems, id:\.self) { $item in
                            Button {
                                mainRouter.route = item.direction
                                isShown =  false
                            } label: {
                                Label {
                                    Text(item.name)
                                } icon: {
                                    Image(systemName: item.label)
                                }
                                .frame(width: viewWidth - 50, alignment: .leading)
                                .padding([.vertical, .horizontal], 12)
                                .background(Color.white.opacity(0.3))
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                                .offset(x:item.offset)
                            }
                            .onAppear{
                                let delay : Double = 0.2 * Double(menuItems.firstIndex(of: item)!)
                                withAnimation(.spring().speed(0.5).delay(delay)){
                                    item.offset = 0.0
                                }
                            }
                        }
                        .padding(.top,20)
                    }
                    .padding(.top,120)
                    Spacer()
                }
            }
            
            .frame(width: viewWidth, height: frame.height)
        }
        .preferredColorScheme(.dark)
    }

}

struct MenuView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        MenuView(isShown: .constant(true))
            .environmentObject(MainRouter())
    }
}
