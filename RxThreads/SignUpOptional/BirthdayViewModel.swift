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
    
    let inputDate = PublishSubject<Date>()
    
    let outputYear = PublishRelay<String>()
    let outputMonth = PublishRelay<String>()
    let outputDay = PublishRelay<String>()
    let outputValidationText = PublishRelay<String>()
    let outputValidation = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputDate
            .bind(with: self) { owner, value in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
                owner.outputYear.accept("\(components.year!)년")
                owner.outputMonth.accept("\(components.month!)월")
                owner.outputDay.accept("\(components.day!)일")
                
                let ageComponents = Calendar.current.dateComponents([.year], from: value, to: Date())
                if let age = ageComponents.year, age > 17 {
                    owner.outputValidationText.accept("만 \(age)세로 가입 가능한 나이입니다.")
                    owner.outputValidation.accept(true)
                } else {
                    owner.outputValidationText.accept("만 17세 이상만 가입 가능합니다.")
                    owner.outputValidation.accept(false)
                }
            }.disposed(by: disposeBag)
        
    }
    
}
