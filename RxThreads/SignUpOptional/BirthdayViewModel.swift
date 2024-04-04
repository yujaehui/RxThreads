//
//  BirthdayViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    struct Input {
        let birthday: ControlProperty<Date>
        let next: ControlEvent<Void>
    }
    
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        let stateText: Driver<String>
        let isEnabled: Driver<Bool>
        let next: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let year = input.birthday.map { self.transformDateComponents(date: $0) }.map { "\($0.year!)년" }.asDriver(onErrorJustReturn: "")
        let month = input.birthday.map { self.transformDateComponents(date: $0) }.map { "\($0.month!)월" }.asDriver(onErrorJustReturn: "")
        let day = input.birthday.map { self.transformDateComponents(date: $0) }.map { "\($0.day!)일" }.asDriver(onErrorJustReturn: "")
        
        let stateText = input.birthday
            .map { self.transformAgeComponents(date: $0) }
            .map { value in
                if let age = value.year, age > 17 {
                    "만 \(age)세로 가입 가능한 나이입니다"
                } else {
                    "만 17세 이상만 가입 가능합니다"
                }
            }
            .asDriver(onErrorJustReturn: "")
        
        let isEnabled = input.birthday
            .map { self.transformAgeComponents(date: $0) }
            .map { value in
                if let age = value.year, age > 17 {
                    true
                } else {
                    false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(year: year, month: month, day: day, stateText: stateText, isEnabled: isEnabled, next: input.next)
    }
    
    func transformDateComponents(date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: date)
    }
    
    func transformAgeComponents(date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year], from: date, to: Date())
    }
}
