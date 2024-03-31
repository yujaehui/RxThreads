//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let phoneStateLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let identificationNumber = Observable.just("010")
    let stateText = BehaviorSubject(value: "10자 이상 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
        
        
        
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(phoneStateLabel)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        phoneStateLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bind() {
        identificationNumber.bind(to: phoneTextField.rx.text).disposed(by: disposeBag)
        stateText.bind(to: phoneStateLabel.rx.text).disposed(by: disposeBag)
        
        let vaildation = phoneTextField.rx.text.orEmpty
        vaildation.map { text -> (isVaild: Bool, message: String) in
            if Int(text) == nil {
                return (false, "숫자만 입력해주세요")
            } else if text.count <= 10 {
                return (false, "11자 이상 입력해주세요")
            }  else {
                return (true, "")
            }
        }.bind(with: self) { owner, value in
            owner.nextButton.isEnabled = value.isVaild
            owner.phoneStateLabel.isHidden = value.isVaild
            owner.nextButton.backgroundColor = value.isVaild ? .systemBlue : .systemGray
            
            owner.phoneStateLabel.text = value.message
        }.disposed(by: disposeBag)
        
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
}
