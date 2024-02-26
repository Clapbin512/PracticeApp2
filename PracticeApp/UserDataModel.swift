//
//  UserDataModel.swift
//  PracticeApp
//
//  Created by ki Co on 2/13/24.
//

import Foundation

enum Section {
    case user
}

struct UserDataModel: Codable, Hashable {
    let userId: Int
    let email: String
    let firstName: String
    let lastName: String
    let imageURL: String
}
