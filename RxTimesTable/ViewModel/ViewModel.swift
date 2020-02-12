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
    func request()
}

protocol ViewModelOutput {
    var number: Observable<String> {get}
}

protocol ViewModelType {
    var inputs: ViewModelInput {get}
    var outputs: ViewModelOutput {get}
}

class ViewModel: ViewModelInput,ViewModelOutput,ViewModelType {
    var model: Model
    
    init() {
        model = Model(number: BehaviorRelay(value:""))
        self.number = model.number.asObservable()
    }
    
    var number: Observable<String>
    
    var inputs: ViewModelInput {return self}
    
    var outputs: ViewModelOutput {return self}
    
    func isValid(number:String)->Bool {
        return number.hasCharaters()
    }
}

extension ViewModel {
    func request() {
        print(inputs)
    }
}
