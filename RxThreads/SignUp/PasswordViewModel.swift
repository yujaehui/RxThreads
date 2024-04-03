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
    
    let inputPasswordText = PublishSubject<String>()

    let outputPasswordValidationText = PublishRelay<String>()
    let outputPasswordValidation = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputPasswordText
            .map { $0.count >= 8 }
            .bind(with: self, onNext: { owner, value in
                owner.outputPasswordValidationText.accept(value ? "" : "8자 이상 입력해주세요.")
                owner.outputPasswordValidation.accept(value)
            })
            .disposed(by: disposeBag)
    }
    
}
