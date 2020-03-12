//
//  ViewController.swift
//  RxTimesTable
//
//  Created by Myeong Soo on 2020/02/12.
//  Copyright © 2020 Myeong Soo. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/*
     구구단 프로젝트
     텍스트 필드에 숫자를 입력하면, 레이블에 숫자에 해당하는 구구단을 출력해주기
     요구사항
     1. 입력되는 데이터는 모두 허용, 단 특정 validator를 사용하여 숫자만 들어오게끔 제어
     2. 텍스트 필드의 값이 변경되면 입력된 단에 해당하는 구구단을 출력함
 */

class ViewController: UIViewController {

    weak var inputTextfield: UITextField!
    weak var outputLabel: UILabel!

    let disposeBag = DisposeBag()
    var viewModel = ViewModel()
    
    var resultList:[Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }

    func setUp() {
        setUpInputTextfield()
        setUpOutputLabel()
    }

    func setUpInputTextfield() {
        self.inputTextfield = UITextField()
        self.inputTextfield.borderStyle = .roundedRect
        self.inputTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(inputTextfield)
        
        self.inputTextfield.snp.makeConstraints{ make in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.top.equalTo(80)
            make.height.equalToSuperview().multipliedBy(0.06)
        }

        self.inputTextfield.rx.text.orEmpty
            .map{$0 as String}
            .bind(to: viewModel.inputs.model.number)
            .disposed(by: disposeBag)
    }

    func setUpOutputLabel() {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.outputLabel = label
        self.view.addSubview(outputLabel)
        
        self.outputLabel.snp.makeConstraints{ make in
            make.leading.equalTo(inputTextfield.snp.leading)
            make.trailing.equalTo(inputTextfield.snp.trailing)
            make.top.equalTo(inputTextfield.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        viewModel.resultString
        .map({$0 as String})
        .bind(to:self.outputLabel.rx.text)
        .disposed(by: disposeBag)
        
        self.outputLabel.rx.observe(String.self, "text")
            .subscribe(onNext: { text in
                DispatchQueue.main.async {
                    self.outputLabel.text = text
                }
            }).disposed(by: disposeBag)
    }
}
