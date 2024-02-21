//
//  CollectionViewCell.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(profileImageView)
        contentsStackView.addArrangedSubview(nameLabel)
        contentsStackView.addArrangedSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            contentsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentsStackView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.8),
            contentsStackView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.8)
        ])
        
        contentsStackView.backgroundColor = .white
        profileImageView.backgroundColor = .darkGray
    }
    
    func setupModel(model: UserDataModel) {
        if let url = URL(string: model.imageURL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image =  UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.profileImageView.image = image
                        }
                    }
                }
            }
        }
        nameLabel.text = "\(model.firstName) \(model.lastName)"
        emailLabel.text = model.email
    }
}
