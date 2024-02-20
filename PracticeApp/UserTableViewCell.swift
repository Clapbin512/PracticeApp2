//
//  TableViewCell.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupView(userDataModel: UserDataModel) {
        firstNameLabel.text = userDataModel.firstName
        lastNameLabel.text = userDataModel.lastName
    }

}
