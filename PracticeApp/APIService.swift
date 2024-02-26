//
//  APIService.swift
//  PracticeApp
//
//  Created by ki Co on 2/14/24.
//

import Foundation
import Alamofire

let url = "https://reqres.in/api/"

//enum RequestType: String {
//    case users = "users"
//}

class APIService {
//    static let shared = APIService()
    
    static func getUsers(completion: @escaping ([UserDataModel]?) -> Void) {
        var userDataModels: [UserDataModel] = []
        
        AF.request(url + "users").responseData { response in
//            debugPrint("Response: \(response)")
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let users = json["data"] as? [[String: Any]] {
                        for user in users {
                            if let imageURL = user["avatar"] as? String,
                               let email = user["email"] as? String,
                               let firstName = user["first_name"] as? String,
                               let id = user["id"] as? Int,
                               let lastName = user["last_name"] as? String {
                                userDataModels.append(UserDataModel(userId: id, email: email, firstName: firstName, lastName: lastName, imageURL: imageURL))
                            }
                        }
                        completion(userDataModels)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
