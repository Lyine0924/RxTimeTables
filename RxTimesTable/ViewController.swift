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
     구구단 프로젝트23
     텍스트 필드에 숫자를 입력하면, 레이블에 숫자에 해당하는 구구단을 출력해주기
     요구사항
     1. 입력되는 데이터는 모두 허용, 단 특정 validator를 사용하여 숫자만 들어오게끔 제어
     2. 텍스트 필드의 값이 변경되면 입력된 단에 해당하는 구구단을 출력함
 */

class ViewController: UIViewController {

    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var outputLabel: UILabel!

    let disposeBag = DisposeBag()
    var viewModel:ViewModel!
//    let strProperty = BehaviorRelay(value: "")
    
    var resultList:[Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ViewModel()
        uiSetup()
    }

    func uiSetup() {
        setUpInputTextfield()
        setUpOutputLabel()
    }

    func setUpInputTextfield() {

        /*
        self.inputTextfield = UITextField()
        self.view.addSubview(inputTextfield)
        
        self.inputTextfield.snp.makeConstraints{ make in
            make.leading.equalTo(30)
            make.trailing.equalTo(30)
            make.centerY.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        */

        // inputTextfield의 데이터 스트림을 observer? 할 수 있는 기능이 필요
        self.inputTextfield.delegate = self
        self.inputTextfield.rx.text.orEmpty
            .map{$0 as String}
            .bind(to: viewModel.inputs.model.number)
            .disposed(by: disposeBag)
        
        viewModel.outputs.number
            .map{$0 as String}
            .bind(to:self.outputLabel.rx.text)
            .disposed(by: disposeBag)
        
//        self.strProperty
//            .filter{$0.isEmpty == false}
//            .subscribe(onNext:{
//                print("result is : \($0)")
//            }).disposed(by: disposeBag)
    }

    func setUpOutputLabel() {

        /*
        self.outputLabel = UILabel()
        self.outputLabel.text = "test"
        self.view.addSubview(outputLabel)
        
        self.outputLabel.snp.makeConstraints{ make in
            make.leading.equalTo(30)
            make.trailing.equalTo(30)
            make.top.equalTo(inputTextfield.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        */
        
        self.outputLabel.rx.observe(String.self, "text")
            .subscribe(onNext: { text in
                self.changeLabelValue(text: text!) { result in
                    DispatchQueue.main.async {
                        self.outputLabel.text = result
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func changeLabelValue(text:String,completion: @escaping (String)->Void){
        let resultTextList = makeTableList(number: text)
        if resultTextList.isEmpty {return}
        
        var resultStr:String = ""
        var count:Int = 1
        
        for result in resultTextList {
            resultStr += "\(text) * \(count) = \(result)"
            resultStr += "\n"
            count += 1
        }
        completion(resultStr)
    }
    
    func makeTableList(number:String)->[String]{
        let orders = [1,2,3,4,5,6,7,8,9]
        guard let number = Int(number) else {
            return []
        }
        var tableList:[String] = [String]()
        for num in orders {
            // bounds error expected
            let mumltipy = String(number * num)
            tableList.append(mumltipy)
        }
        return tableList
    }
}

extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let newLength: Int = newString.length

        if newLength > 10 {return false}
        
        switch textField {
        case inputTextfield:
            let utf8Char = string.cString(using: .utf8)
            let isBackSpace = strcmp(utf8Char, "\\b")

            if string.hasCharaters() || isBackSpace == -92 {
                return true
            }
            return false
        default: break
        }
        return true
    }
}
