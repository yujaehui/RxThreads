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
