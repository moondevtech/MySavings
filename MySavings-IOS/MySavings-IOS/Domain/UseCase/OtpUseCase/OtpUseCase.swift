//
//  OtpUserCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 30/12/2022.
//

import Foundation
import Combine


class OtpUseCase {
    
    var subscriptions : Set<AnyCancellable> = .init()
    weak var delegate : OtpOutputType?
    
    
    init(_ delegate  :  OtpOutputType) {
        self.delegate = delegate
    }
    
    func onDigitAdded(_ digit : String){
        delegate?.handleOuput(.digitAdded(DigitModel(value: digit)))
    }
    
    
    func onRemove(digits : [DigitModel]){
        digits
            .publisher
            .flatMap(maxPublishers : .max(1)){
                Just($0)
                .delay(for: 0.1, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            }
            .collect()
            .sink {[weak self] result in
                self?.delegate?.handleOuput(.removeDigit([]))
            }
            .store(in: &subscriptions)
    }
    
    func onAnimateOut(digits : [DigitModel]){
        digits
            .enumerated()
            .reversed()
            .publisher
            .map(\.offset)
            .flatMap(maxPublishers : .max(1)){
                Just($0)
                .delay(for: 0.1, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            }
            .sink {[weak self] index in
                self?.delegate?.handleOuput(.animatedOut(index))
            }
            .store(in: &subscriptions)
            
        
    }
    
}
