//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nicknameStateLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    let viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }

    func bind() {
        let nickname = nicknameTextField.rx.text.orEmpty
        let next = nextButton.rx.tap
        let input = NicknameViewModel.Input(nickname: nickname, next: next)
        
        let output = viewModel.transform(input: input)
        
        output.nickname.drive(nicknameTextField.rx.text).disposed(by: disposeBag)
        output.stateText.drive(nicknameStateLabel.rx.text).disposed(by: disposeBag)
        
        output.isEnabled.drive(with: self) { owner, value in
            owner.nextButton.isEnabled = value
            owner.nextButton.backgroundColor = value ? .systemBlue : .systemGray
            owner.nicknameStateLabel.isHidden = value
        }.disposed(by: disposeBag)
        
        output.next.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameStateLabel)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nicknameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
