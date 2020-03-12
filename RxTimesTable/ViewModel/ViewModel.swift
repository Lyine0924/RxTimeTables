//
//  ViewModel.swift
//  RxTimesTable
//
//  Created by Myeong Soo on 2020/02/12.
//  Copyright © 2020 Myeong Soo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInput {
    var model: Model {get set}
}

protocol ViewModelOutput {
    var numberOfString: Observable<String> {get}
}

protocol ViewModelType {
    var inputs: ViewModelInput {get}
    var outputs: ViewModelOutput {get}
}

class ViewModel: ViewModelInput,ViewModelOutput,ViewModelType {
    var inputs: ViewModelInput {return self}
    var outputs: ViewModelOutput {return self}
    
    var numberOfString: Observable<String>
    var model = Model(number: BehaviorRelay(value:""))
    
    let disposeBag = DisposeBag()
    let resultString = PublishSubject<String>()
    
    init() {
        self.numberOfString = model.number.asObservable()
        self.numberOfString
            .filter({
                $0.hasCharaters()
            })
            .subscribe(onNext: {
                self.makeTableList(number: $0)
            }).disposed(by: disposeBag)
    }
    
    private func makeTableList(number:String){
        var result = ""
        
        guard let number = Int(number) else {
            return
        }
        
        for i in 1..<10 {
            // bounds error expected
            result += "\(number) * \(i) = \(String(number * i))"
            result += "\n"
        }
        resultString.onNext(result)
    }
}
