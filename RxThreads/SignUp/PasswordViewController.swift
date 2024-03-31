//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let passwordStateLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let stateText = Observable.just("8자 이상 입력해주세요.")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(passwordStateLabel)
        view.addSubview(nextButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordStateLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bind() {
        
        stateText.bind(to: passwordStateLabel.rx.text).disposed(by: disposeBag) // to, 그대로 전달
        
        // vaildation: observable
        // -> passwordStateLabel, nextButton: observer
        let vaildation = passwordTextField.rx.text.orEmpty.map { $0.count >= 8 } // 8자 이상이면 true
        vaildation.bind(to: passwordStateLabel.rx.isHidden ,nextButton.rx.isEnabled).disposed(by: disposeBag) // to, 그대로 전달
        vaildation.bind(with: self) { owner, value in
            owner.nextButton.backgroundColor = value ? .systemBlue : .systemGray
        }.disposed(by: disposeBag)
        

        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
}
