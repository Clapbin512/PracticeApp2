//
//  UserCollectionHeaderView.swift
//  PracticeApp
//
//  Created by ki Co on 2/27/24.
//

import UIKit

class UserCollectionHeaderView: UICollectionReusableView {
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupView() {
        headerLabel.text = "사용자"
        headerLabel.textColor = .blue
    }
}
