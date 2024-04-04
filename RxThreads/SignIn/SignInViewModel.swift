//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let signIn: ControlEvent<Void>
        let signUp: ControlEvent<Void>
    }
    
    struct Output {
        let email: Driver<String>
        let password: Driver<String>
        let signIn: ControlEvent<Void>
        let signUp: ControlEvent<Void>
        let isEnabled: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let email = input.email.asDriver()
        let password = input.password.asDriver()
        let emailIsEnabled = input.email.map { $0.count > 8 && $0.contains("@")}
        let passwordIsEnabled = input.password.map { $0.count > 8 }
        let isEnabled = Observable.merge(emailIsEnabled, passwordIsEnabled).asDriver(onErrorJustReturn: false)
        
        return Output(email: email, password: password, signIn: input.signIn, signUp: input.signUp, isEnabled: isEnabled)
    }
    
}
