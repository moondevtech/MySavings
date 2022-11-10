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
    var direction : String
}

struct MenuView: View {
    
    var menuItems : [MenuItems] = .init(arrayLiteral:
        MenuItems(name: "Card management", label: "signature", direction: "toGraph"),
        MenuItems(name: "Expenses", label: "lines.measurement.horizontal", direction: "toGraph"),
        MenuItems(name: "History", label: "book", direction: "toHistory"),
        MenuItems(name: "Settings", label: "wrench.and.screwdriver", direction: "toSettings")
    )
    
    @Binding var isShown : Bool
    
    var body: some View {
        GeometryReader { geo in
            let frame = geo.frame(in: .global)
            ZStack{
                Color.black
                List{
                    
                    Section{
                        Button {
                            isShown =  false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }

                    }
                    Section("Menu") {
                        ForEach(menuItems, id:\.self) { item in
                            
                            Button {
                                
                            } label: {
                                Label {
                                    Text(item.name)
                                } icon: {
                                    Image(systemName: item.label)
                                }
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .frame(width: frame.width * 0.75)
        }
        .preferredColorScheme(.dark)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    

    
    static var previews: some View {
        MenuView(isShown: .constant(true))
    }
}
