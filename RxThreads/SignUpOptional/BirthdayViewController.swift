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
    
    let infoLabel: UILabel = {
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
    
    let year = PublishSubject<Int>()
    let month = PublishSubject<Int>()
    let day = PublishSubject<Int>()
    
    let info = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
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
        year.map { "\($0)년" }.bind(to: yearLabel.rx.text).disposed(by: disposeBag)
        month.map { "\($0)월 "}.bind(to: monthLabel.rx.text).disposed(by: disposeBag)
        day.map { "\($0)일 "}.bind(to: dayLabel.rx.text).disposed(by: disposeBag)
        
        info.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(with: self) { owner, value in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
                owner.year.onNext(components.year!)
                owner.month.onNext(components.month!)
                owner.day.onNext(components.day!)
                
                let ageComponents = Calendar.current.dateComponents([.year], from: value, to: Date())
                print(ageComponents.year!)
                if let age = ageComponents.year, age > 17 {
                    owner.info.onNext("만 \(age)세로 가입 가능한 나이입니다.")
                    owner.nextButton.isEnabled = true
                    owner.nextButton.backgroundColor = .systemBlue
                } else {
                    owner.info.onNext("만 17세 이상만 가입 가능합니다.")
                    owner.nextButton.isEnabled = false
                    owner.nextButton.backgroundColor = .systemGray
                }
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            print("가입완료")
        }.disposed(by: disposeBag)
    }
}
