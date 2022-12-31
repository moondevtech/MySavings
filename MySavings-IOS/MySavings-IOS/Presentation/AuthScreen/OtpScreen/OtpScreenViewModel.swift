//
//  OtpScreenViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation
import Combine

enum OtpScreenError : LocalizedError {
    case phoneNumberError
}

class OtpScreenViewModel : ObservableObject {
    
    lazy var useCase = OtpUseCase(self)
    lazy var phoneNumberUseCase = PhoneNumberCheckUseCase(self)
    var digitIndexToRemoveAnimateOut : PassthroughSubject<Int, Never> = .init()
    var moveFirstDigitIn : PassthroughSubject<Int, Never> = .init()
    var formattedPhoneNumberReceived : PassthroughSubject<String, Never> = .init()
    var showError : PassthroughSubject<OtpScreenError, Never> = .init()
    var otpScreenScrollDestination : PassthroughSubject<Int, Never> = .init()
    var finishedRemovingEvent : PassthroughSubject<Void, Never> = .init()
    var flags : [Flag] = []
    @Published var selectedFlag : Flag?
    @Published var searchText : String = ""
    
    var searchResults: [Flag] {
        if searchText.isEmpty {
            return flags
        } else {
            return flags.filter { $0.name.contains(searchText) || $0.code.contains(searchText) || $0.dial_code.contains(searchText) }
        }
    }
    
    @Published var digits : [DigitModel] = .init(arrayLiteral :.init(value: ""))
    
    init(){
        let reader = BundleResourceReader()
        flags = reader.fetch(.json(ResourceProvide.flags), type: [Flag].self)
        selectedFlag = flags.first(where: {$0.emoji == "🇺🇸"})
    }
    
    private func handleDigitInput(_ digit : String){
        digits.lastModifiable.value = String(digit.prefix(1))
        useCase.onDigitAdded(digits.lastModifiable.value)
    }
    
    private func handleDigitAdded(_ digit : DigitModel){
        if digits.count < 4 {
            digits.append(.init(value: ""))
        }
    }
    
    private func handleAnimationOut(_ index : Int){
        digitIndexToRemoveAnimateOut.send(index)
    }
    
    private func handleRemovedDigit(_ digits : [DigitModel]){
        self.digits = [.init(value: "")]
        finishedRemovingEvent.send()
    }
    
    private func handleFormattedPhoneNumber(_ phoneNumber : Result<String, PhoneNumberCheckError>){
        switch phoneNumber {
        case .success(let success):
            formattedPhoneNumberReceived.send(success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){[weak self] in
                self?.otpScreenScroll(to: 1)
            }
        case .failure(let failure):
            showError.send(.phoneNumberError)
            break
        }
        
    }
    
    func otpScreenScroll(to destionationId : Int) {
        otpScreenScrollDestination.send(destionationId)
    }
}

extension OtpScreenViewModel : OtpInputType{
    
    func handleInput( _ input : OtpInput){
        switch input {
        case .digit(let digit):
            handleDigitInput(digit)
        case .animateOut:
            useCase.onAnimateOut(digits: digits)
            handleInput(.remove)
        case .remove:
            useCase.onRemove(digits: Array(digits[1...]).reversed())
        case .selectFlag(let flag) :
            selectedFlag =  flag
        }
    }
}

extension OtpScreenViewModel : OtpOutputType{
    
    func handleOuput(_ output: OtpOutput) {
        switch output {
        case .digitAdded(let digit):
            handleDigitAdded(digit)
        case .removeDigit(let digits):
            handleRemovedDigit(digits)
        case .animatedOut(let index):
            handleAnimationOut(index)
        case .error(let error):
            //handle error
            break
        }
    }
    
}


extension OtpScreenViewModel : PhoneNumberCheckInputType {
    func handlePhoneInput(_ input: PhoneNumberCheckInput) {
        switch input {
        case .number(let phoneNumberCheckModel):
            phoneNumberUseCase.checkPhoneNumberInput(phoneNumberCheckModel)
        }
    }
}


extension OtpScreenViewModel : PhoneNumberCheckOutputType {
    
    func handlePhoneOutput(_ output: PhoneNumberCheckOutput) {
        switch output {
        case .formattedNumber(let result):
            handleFormattedPhoneNumber(result)
        }
    }
    
    
}
