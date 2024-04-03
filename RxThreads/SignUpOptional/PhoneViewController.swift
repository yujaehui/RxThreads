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
        
    let disposeBag = DisposeBag()
    
    let viewModel = PhoneViewModel()
    
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
        viewModel.identifierNumber.asDriver().drive(phoneTextField.rx.text).disposed(by: disposeBag)
        
        viewModel.outputValidationText.asDriver(onErrorJustReturn: "").drive(phoneStateLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputValidation.asDriver(onErrorJustReturn: false).drive(with: self) { owner, value in
            owner.phoneStateLabel.isHidden = value
            owner.nextButton.isEnabled = value
            owner.nextButton.backgroundColor = value ?  .systemBlue : .systemGray
        }.disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty.bind(to: viewModel.inputPhoneText).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
}
