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
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonClikced: ControlEvent<Void>
    }
    
    struct Output {
        let searchList: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let searchText = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { value in
                if value.isEmpty {
                    self.data
                } else {
                    self.data.filter { $0.contains(value) }
                }
            }
        
        let searchButtonClikced = input.searchButtonClikced
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { value in
                if value.isEmpty {
                    self.data
                } else {
                    self.data.filter { $0.contains(value) }
                }
            }
            
        let searchList = Observable.merge(searchText, searchButtonClikced).asDriver(onErrorJustReturn: self.data)
                
        return Output(searchList: searchList)
        
    }
}
