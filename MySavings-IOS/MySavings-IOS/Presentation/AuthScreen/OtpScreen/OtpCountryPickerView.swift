//
//  OtpCountryPickerView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import SwiftUI

struct OtpCountryPickerView: View , OtpViewScrolled {
    
    var index : Int = 1
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : OtpScreenViewModel
    
    var body: some View {
        List(viewModel.searchResults, id:\.self,
             selection : $viewModel.selectedFlag) { flag in
            HStack{
                Text(flag.emoji)
                Text(flag.dial_code)
                Text(flag.name)
            }
        }
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarTitle("Pick a country")
        .onReceive(viewModel.$selectedFlag, perform: { flag in
            dismiss.callAsFunction()
        })
    }
}

struct OtpCountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        OtpCountryPickerView()
            .environmentObject(OtpScreenViewModel())
    }
}
