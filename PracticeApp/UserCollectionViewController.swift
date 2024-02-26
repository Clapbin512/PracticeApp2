//
//  CollectionViewController.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import UIKit

class UserCollectionViewController: UIViewController {
    
    var userDataModels: [UserDataModel]?
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, UserDataModel>?
    
    private lazy var userCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.delegate = self
        
        // 3. UICollectionViewDiffableDataSource + dequeueReusableCell 방식
//        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "UserCollectionViewCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupView() {
        view.addSubview(userCollectionView)
        userCollectionView.translatesAutoresizingMaskIntoConstraints = false
        userCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        userCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        userCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // 3. UICollectionViewDiffableDataSource + dequeueReusableCell 방식
//        diffableDataSource = UICollectionViewDiffableDataSource<Section, UserDataModel>(collectionView: userCollectionView) { collectionView, indexPath, itemIdentifier in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as? UserCollectionViewCell else { return UICollectionViewCell() }
//            cell.setupModel(model: itemIdentifier)
//            return cell
//        }
//
        // 2. UICollectionViewDiffableDataSource + UICollectionView.CellRegistration 방식
        // cell register
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, UserDataModel> {
            (cell, indexPath, userDataModel) in
            cell.setupModel(model: userDataModel)
        }

        diffableDataSource = UICollectionViewDiffableDataSource<Section, UserDataModel>(collectionView: self.userCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserDataModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        userCollectionView.dataSource = diffableDataSource
        
        APIService.getUsers { userDataModels in
            // 1. UICollectionViewDataSource 방식
//            self.userDataModels = userDataModels
//            self.userCollectionView.reloadData()
            
            // 2-1. UICollectionViewDiffableDataSource + UICollectionView.CellRegistration 방식 - 최로 로딩 후 사라지는 현상 발생..
//            // cell register
//            let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, UserDataModel> {
//                (cell, indexPath, userDataModel) in
//                cell.setupModel(model: userDataModel)
//            }

//            let dataSource = UICollectionViewDiffableDataSource<Section, UserDataModel>(collectionView: self.userCollectionView) {
//                (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserDataModel) -> UICollectionViewCell? in
//                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//            }
//            self.userCollectionView.dataSource = dataSource

            var snapshot = NSDiffableDataSourceSnapshot<Section, UserDataModel>()
            snapshot.appendSections([.user])
            guard let items = userDataModels else { return }
            snapshot.appendItems(items, toSection: .user)
            self.diffableDataSource?.apply(snapshot)
            // 2-1. UICollectionViewDiffableDataSource + UICollectionView.CellRegistration 방식 - 최로 로딩 후 사라지는 현상 발생..
//            dataSource.apply(snapshot)
        }
    }
}

extension UserCollectionViewController: UICollectionViewDelegate {
    
}
