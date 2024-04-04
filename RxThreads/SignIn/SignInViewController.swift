//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        let email = emailTextField.rx.text.orEmpty
        let password = passwordTextField.rx.text.orEmpty
        let signIn = signInButton.rx.tap
        let signUp = signUpButton.rx.tap
        let input = SignInViewModel.Input(email: email, password: password, signIn: signIn, signUp: signUp)
        
        let output = viewModel.transform(input: input)
        output.email.drive(emailTextField.rx.text).disposed(by: disposeBag)
        output.password.drive(passwordTextField.rx.text).disposed(by: disposeBag)
        output.signIn.bind(with: self) { owner, _ in
            print("Sign In Tapped")
        }.disposed(by: disposeBag)
        output.signUp.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
        output.isEnabled.drive(signInButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
