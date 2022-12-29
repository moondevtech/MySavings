//
//  TitleTable.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import SwiftUI

struct TitleTab: View {
    
    var content : String = "Content"
    
    var body: some View {
        Text(content)
            .font(.title.bold())
            .foregroundColor(.white)
    }
}

struct TitleTable_Previews: PreviewProvider {
    static var previews: some View {
        TitleTab()
    }
}
