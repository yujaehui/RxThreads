//
//  SignUpViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    struct Input {
        let email: ControlProperty<String>
        let next: ControlEvent<Void>
        let validation: ControlEvent<Void>
    }
    
    struct Output {
        let email: Driver<String>
        let stateText: Driver<String>
        let isEnabled: Driver<Bool>
        let next: ControlEvent<Void>
        let validation: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let email = input.email.asDriver()
        let stateText = input.email.map { $0.count > 8 && $0.contains("@") }.map { $0 ? "" : "이메일 형식에 맞게 8자 이상 입력해주세요"}.asDriver(onErrorJustReturn: "")
        let isEnabled = input.email.map { $0.count > 8 && $0.contains("@") }.asDriver(onErrorJustReturn: false)
        let validation = input.validation.map { "중복확인" }.asDriver(onErrorJustReturn: "")
        
        return Output(email: email, stateText: stateText, isEnabled: isEnabled, next: input.next, validation: validation)
    }
}
