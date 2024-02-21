//
//  TableViewNavigationController.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import UIKit
import Alamofire

class UserTableViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var userDataModels: [UserDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        userTableView.dataSource = self

        APIService.getUsers() { userDataModels in
            self.userDataModels = userDataModels
            self.userTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewSegue" {
            if let detailViewController = segue.destination as? DetailViewController {
                if let selectedIndex = self.userTableView.indexPathForSelectedRow?.row,
                   let userDataModel = self.userDataModels?[selectedIndex] {
                    detailViewController.profileImageViewURL = userDataModel.imageURL
                    detailViewController.idString = String(userDataModel.id)
                    detailViewController.nameString = "\(userDataModel.firstName) \(userDataModel.lastName)"
                    detailViewController.emailString = userDataModel.email
                }
            }
        }
    }
}

extension UserTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.userDataModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell,
              let userDataModels = self.userDataModels else { return UserTableViewCell() }
        
        cell.setupView(userDataModel: userDataModels[indexPath.item])
        
        return cell
    }
}
