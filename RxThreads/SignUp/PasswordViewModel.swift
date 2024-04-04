//
//  PasswordViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    struct Input {
        let password: ControlProperty<String>
        let next: ControlEvent<Void>
    }
    
    struct Output {
        let password: Driver<String>
        let stateText: Driver<String>
        let isEnabled: Driver<Bool>
        let next: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let password = input.password.asDriver()
        let stateText = input.password.map { $0.count > 8 }.map { $0 ? "" : "8자 이상 입력해주세요"}.asDriver(onErrorJustReturn: "")
        let isEnabled = input.password.map { $0.count > 8 }.asDriver(onErrorJustReturn: false)
        
        return Output(password: password, stateText: stateText, isEnabled: isEnabled, next: input.next)
    }
}
