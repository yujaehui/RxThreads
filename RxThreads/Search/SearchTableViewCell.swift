//
//  SearchTableViewCell.swift
//  RxThreads
//
//  Created by Jaehui Yu on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchTableViewCell: UITableViewCell {
    
    let sampleImageView = UIImageView()
    let sampleLabel = UILabel()
    let sampleButton = UIButton()
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureHierarchy() {
        contentView.addSubview(sampleImageView)
        contentView.addSubview(sampleLabel)
        contentView.addSubview(sampleButton)
    }
    
    func configureView() {
        sampleButton.setTitle("test", for: .normal)
        sampleButton.setTitleColor(.white, for: .normal)
        sampleButton.backgroundColor = .systemBlue
    }
    
    func configureConstraints() {
        sampleImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(20)
            make.size.equalTo(80)
            make.bottom.lessThanOrEqualTo(contentView).inset(10)
        }
        
        sampleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sampleImageView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
        }
        
        sampleButton.snp.makeConstraints { make in
            make.leading.equalTo(sampleLabel.snp.trailing).inset(10)
            make.centerY.equalTo(contentView)
            make.width.equalTo(50)
            make.trailing.equalTo(contentView).inset(20)
        }
    }

}
