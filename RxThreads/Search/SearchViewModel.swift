//
//  SearchViewModel.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    var data = ["a", "b", "c", "d", "aa", "bb", "cc", "dd", "abc", "abcd"]
    lazy var items = BehaviorSubject(value: data)
    
    let inputSearchText = PublishSubject<String>()
    let inputSearchButtonClicked = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputSearchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }.disposed(by: disposeBag)
        
        inputSearchButtonClicked
            .withLatestFrom(inputSearchText)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }.disposed(by: disposeBag)
    }
}
