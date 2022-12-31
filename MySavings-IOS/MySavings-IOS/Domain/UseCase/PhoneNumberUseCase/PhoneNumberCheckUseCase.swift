//
//  PhoneNumberCheckUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/12/2022.
//

import Foundation
import Combine
import PhoneNumberKit


struct PhoneNumberCheckModel {
    var countryCode : String
    var dial_code : String
    var phoneNumber : String
}

enum PhoneNumberCheckError : LocalizedError {
    case wrongInput(Error)
}

enum PhoneNumberCheckInput {
    case number(PhoneNumberCheckModel)
}

enum PhoneNumberCheckOutput {
    case formattedNumber(Result<String, PhoneNumberCheckError>)
}

protocol PhoneNumberCheckInputType {
    func handlePhoneInput( _ input : PhoneNumberCheckInput)
}

protocol PhoneNumberCheckOutputType : AnyObject {
    func handlePhoneOutput( _ output : PhoneNumberCheckOutput)
}

class PhoneNumberCheckUseCase {
    
    
    weak var delegate : PhoneNumberCheckOutputType?
    var subscriptions : Set<AnyCancellable> = .init()
    
    init( _ delegate : PhoneNumberCheckOutputType) {
        self.delegate = delegate
    }
    
    func checkPhoneNumberInput(_ phoneNumber : PhoneNumberCheckModel) {
        let phoneNumberKit = PhoneNumberKit()
        Just(phoneNumber)
            .map { phone -> PhoneNumberCheckOutput in
                do{
                    let result  =  try phoneNumberKit.parse("\(phone.dial_code)\(phone.phoneNumber)", withRegion: phone.countryCode, ignoreType: true)
                    let formatted = phoneNumberKit.format(result, toType : .international)
                    return .formattedNumber(.success(formatted))
                } catch {
                    return .formattedNumber(.failure(.wrongInput(error)))
                }
            }
            .sink{[weak self] completion  in
                self?.delegate?.handlePhoneOutput(completion)
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        delegate =  nil
    }
    
}
