//
//  NicknameViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    struct Input {
        let nickname: ControlProperty<String>
        let next: ControlEvent<Void>
    }
    
    struct Output {
        let nickname: Driver<String>
        let stateText: Driver<String>
        let isEnabled: Driver<Bool>
        let next: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let nickname = input.nickname.asDriver()
        let stateText = input.nickname.map { $0.count > 8 }.map { $0 ? "" : "8자 이상 입력해주세요" }.asDriver(onErrorJustReturn: "")
        let isEnabled = input.nickname.map { $0.count > 8}.asDriver(onErrorJustReturn: false)
        
        return Output(nickname: nickname, stateText: stateText, isEnabled: isEnabled, next: input.next)
    }
}
