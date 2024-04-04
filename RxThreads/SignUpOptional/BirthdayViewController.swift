//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let birthdayStateLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.textAlignment = .center
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    let viewModel = BirthdayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func configureLayout() {
        view.addSubview(birthdayStateLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        birthdayStateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(birthdayStateLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func bind() {
        let birthday = birthDayPicker.rx.date
        let next = nextButton.rx.tap
        let input = BirthdayViewModel.Input(birthday: birthday, next: next)
        
        let output = viewModel.transform(input: input)
        
        output.year.drive(yearLabel.rx.text).disposed(by: disposeBag)
        output.month.drive(monthLabel.rx.text).disposed(by: disposeBag)
        output.day.drive(dayLabel.rx.text).disposed(by: disposeBag)
        output.stateText.drive(birthdayStateLabel.rx.text).disposed(by: disposeBag)
        
        output.isEnabled.drive(with: self) { owner, value in
            owner.nextButton.isEnabled = value
            owner.nextButton.backgroundColor = value ? .systemBlue : .systemGray
        }.disposed(by: disposeBag)
        
        output.next.bind(with: self) { owner, _ in
            print("가입완료")
        }.disposed(by: disposeBag)
    }
}
