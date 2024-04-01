//
//  SearchViewController.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    var data = ["a", "b", "c", "d", "aa", "bb", "cc", "dd", "abc", "abcd"]
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureView()
        configureConstraints()
        setNav()
        bind()
    }
    
    func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.sampleImageView.backgroundColor = .systemGray
                cell.sampleLabel.text = "TEST \(element)"
                cell.sampleButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(SignInViewController(), animated: true)
                    }.disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                print(value)
                owner.data.remove(at: value.0.row)
                owner.items.onNext(owner.data)
            }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }.disposed(by: disposeBag)
    }
    
    func setNav() {
        navigationItem.titleView = searchBar
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    func configureView() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
