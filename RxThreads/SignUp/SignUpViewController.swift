//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let emailStateLabel = UILabel()
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        let email = emailTextField.rx.text.orEmpty
        let next = nextButton.rx.tap
        let validation = validationButton.rx.tap
        let input = SignUpViewModel.Input(email: email, next: next, validation: validation)
        
        let output = viewModel.transform(input: input)
        
        output.email.drive(emailTextField.rx.text).disposed(by: disposeBag)
        output.stateText.drive(emailStateLabel.rx.text).disposed(by: disposeBag)
        
        output.isEnabled.drive(with: self) { owner, value in
            owner.nextButton.isEnabled = value
            owner.nextButton.backgroundColor = value ? .systemBlue : .systemGray
            owner.emailStateLabel.isHidden = value
        }.disposed(by: disposeBag)
        
        output.next.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        output.validation.drive(with: self) { owner, value in
            let alert = UIAlertController(title: "RXThreads", message: "중복확인", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            owner.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(emailStateLabel)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        emailStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
