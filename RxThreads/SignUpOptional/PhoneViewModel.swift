//
//  PhoneViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    struct Input {
        let phone: ControlProperty<String>
        let next: ControlEvent<Void>
    }
    
    struct Output {
        let identifierNumber = BehaviorRelay(value: "010").asDriver()
        let phone: Driver<String>
        let stateText: Driver<String>
        let isEnabled: Driver<Bool>
        let next: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let phone = input.phone.asDriver()
        let stateText = input.phone
            .map { value in
                if Int(value) == nil {
                    "숫자만 입력해주세요"
                } else if value.count <= 10 {
                    "11자 이상 입력해주세요"
                }  else {
                    ""
                }
            }
            .asDriver(onErrorJustReturn: "")
        let isEnabled = input.phone
            .map { value in
                if Int(value) == nil {
                    false
                } else if value.count <= 10 {
                    false
                }  else {
                    true
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(phone: phone, stateText: stateText, isEnabled: isEnabled, next: input.next)
    }
    
    
    let identifierNumber = BehaviorRelay(value: "010")
    
    let inputPhoneText = PublishSubject<String>()
    
    let outputValidationText = PublishRelay<String>()
    let outputValidation = PublishRelay<Bool>()

    let disposeBag = DisposeBag()
    
    init() {
        inputPhoneText
            .map { text -> (isValid: Bool, message: String) in
                if Int(text) == nil {
                    return (false, "숫자만 입력해주세요")
                } else if text.count <= 10 {
                    return (false, "11자 이상 입력해주세요")
                }  else {
                    return (true, "")
                }
            }.bind(with: self) { owner, value in
                owner.outputValidationText.accept(value.message)
                owner.outputValidation.accept(value.isValid)
            }.disposed(by: disposeBag)
    }
}
