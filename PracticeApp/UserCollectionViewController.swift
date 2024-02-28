//
//  CollectionViewController.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import UIKit

class UserCollectionViewController: UIViewController {
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, UserDataModel>?
    
    private lazy var userCollectionView: UICollectionView = {
        // collectionViewCompositionalLayout 세팅
        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let header =  NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        // layout item 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25)
        
        // layout group 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // layout section 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        section.boundarySupplementaryItems = [header]
        
        // collectionView 생성 및 collectionViewCompositionalLayout 적용, delegate 연결
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        
        // addSubview, AutoLayout 설정
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // cell register 및 cell 세팅
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, UserDataModel> {
            (cell, indexPath, userDataModel) in
            cell.setupModel(model: userDataModel)
        }
        
//        let headerRegistration = UICollectionView.SupplementaryRegistration<UserCollectionHeaderView>(elementKind: "header") { (supplementaryView, string, indexPath) in
//            supplementaryView.setupView()
//        }

        // diffableDataSource 생성 및 cellRegistration 적용
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UserDataModel>(collectionView: self.userCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserDataModel) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UserCollectionHeaderView>(elementKind: "header") { (supplementaryView, string, indexPath) in
            supplementaryView.setupView()
        }
        
        diffableDataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.userCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        // diffableDataSource 적용
        userCollectionView.dataSource = diffableDataSource
        
        APIService.getUsers { userDataModels in
            // API 통신 후 snapshot 생성
            var snapshot = NSDiffableDataSourceSnapshot<Section, UserDataModel>()
            snapshot.appendSections([.user])
            guard let items = userDataModels else { return }
            snapshot.appendItems(items, toSection: .user)
            
            // snapshot 적용
            self.diffableDataSource?.apply(snapshot)
        }
    }
}

extension UserCollectionViewController: UICollectionViewDelegate {
    // 셀 터치시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = diffableDataSource?.itemIdentifier(for: indexPath),
           let detailViewController = storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            detailViewController.emailString = selectedItem.email
            detailViewController.idString = "\(selectedItem.userId)"
            detailViewController.nameString = selectedItem.firstName + " " + selectedItem.lastName
            detailViewController.profileImageViewURL = selectedItem.imageURL
            present(detailViewController, animated: true)
        }
    }
}
